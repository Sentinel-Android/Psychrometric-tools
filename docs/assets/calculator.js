(() => {
  // src/psychrometrics/psychrometrics.mjs
  var properties = {
    tdb: { label: "Dry Bulb Temperature", slug: "dry-bulb-temperature", symbol: "DB", unit: "°C" },
    q: { label: "Specific Humidity", slug: "specific-humidity", symbol: "SH", unit: "kg water/kg moist air" },
    rh: { label: "Relative Humidity", slug: "relative-humidity", symbol: "RH", unit: "%" },
    h: { label: "Enthalpy", slug: "enthalpy", symbol: "ET", unit: "kJ/kg dry air" },
    twb: { label: "Wet Bulb Temperature", slug: "wet-bulb-temperature", symbol: "WB", unit: "°C" },
    v: { label: "Specific Volume", slug: "specific-volume", symbol: "SV", unit: "m³/kg dry air" },
    pw: { label: "Vapour Pressure", slug: "vapour-pressure", symbol: "PV", unit: "kPa" },
    tdp: { label: "Dew Point Temperature", slug: "dew-point-temperature", symbol: "DP", unit: "°C" },
    p: { label: "Total Pressure", slug: "atmospheric-pressure", symbol: "PT", unit: "kPa" },
    z: { label: "Height Above Sea Level", slug: "altitude", symbol: "z", unit: "m" }
  };
  var moistureKeys = ["q", "pw", "tdp"];
  var catalogInputs = Object.keys(properties).filter((key) => key !== "p" && key !== "z");
  var catalogPairs = catalogInputs.flatMap(
    (first, index) => catalogInputs.slice(index + 1).map((second) => [first, second])
  );
  var independent = (first, second) => first !== second && !(moistureKeys.includes(first) && moistureKeys.includes(second));
  var molecularRatio = 0.622;
  var dryAirGasConstant = 0.2871;
  var dryAirHeatCapacity = 1.005;
  var vapourHeatCapacity = 1.88;
  var vapourReferenceEnthalpy = 2500;
  var minDryBulb = -60;
  var minSaturationTemperature = -100;
  var maxTemperature = 160;
  var tolerance = 1e-11;
  var minAltitude = -500;
  var maxAltitude = 11e3;
  var seaLevelPressure = 101.325;
  var altitudeFactor = 225577e-10;
  var atmosphereExponent = 5.2559;
  function atmosphericPressure(altitude) {
    if (!Number.isFinite(altitude) || altitude < minAltitude || altitude > maxAltitude) {
      throw new Error("Enter an altitude between −500 and 11,000 m.");
    }
    return seaLevelPressure * (1 - altitudeFactor * altitude) ** atmosphereExponent;
  }
  function validatePressure(value) {
    if (!Number.isFinite(value) || value <= 0) throw new Error("Enter a total pressure greater than zero in kPa.");
    return value;
  }
  function altitudeFromPressure(pressure) {
    validatePressure(pressure);
    const low = atmosphericPressure(maxAltitude);
    const high = atmosphericPressure(minAltitude);
    if (pressure < low - 5e-7 || pressure > high + 5e-7) {
      throw new Error("Use a total pressure from " + low.toFixed(6) + " to " + high.toFixed(6) + " kPa for this altitude model.");
    }
    return Math.max(minAltitude, Math.min(
      maxAltitude,
      (1 - (pressure / seaLevelPressure) ** (1 / atmosphereExponent)) / altitudeFactor
    ));
  }
  function totalPressure(air) {
    if (typeof air === "number") return atmosphericPressure(air);
    return air.mode === "pressure" ? validatePressure(air.value) : atmosphericPressure(air.value);
  }
  function saturationPressure(temperature) {
    const t = temperature + 273.15;
    let logPressure;
    if (temperature <= 0.01) {
      logPressure = -5674.5359 / t + 6.3925247 - 9677843e-9 * t + 62215701e-14 * t ** 2 + 20747825e-16 * t ** 3 - 9484024e-19 * t ** 4 + 4.1635019 * Math.log(t);
    } else {
      logPressure = -5800.2206 / t + 1.3914993 - 0.048640239 * t + 41764768e-12 * t ** 2 - 14452093e-15 * t ** 3 + 6.5459673 * Math.log(t);
    }
    return Math.exp(logPressure) / 1e3;
  }
  function bisect(fn, target, low, high) {
    if (!Number.isFinite(target) || low > high) return null;
    let lowerError = fn(low) - target;
    const upperError = fn(high) - target;
    const limit = Math.max(1e-15, Math.abs(target) * tolerance);
    if (Math.abs(lowerError) <= limit) return low;
    if (Math.abs(upperError) <= limit) return high;
    if (Math.sign(lowerError) === Math.sign(upperError)) return null;
    for (let iteration = 0; iteration < 64; iteration++) {
      const middle = low + (high - low) / 2;
      if (middle === low || middle === high) return middle;
      const error = fn(middle) - target;
      if (error === 0) return middle;
      if (Math.sign(error) === Math.sign(lowerError)) {
        low = middle;
        lowerError = error;
      } else {
        high = middle;
      }
    }
    return low + (high - low) / 2;
  }
  function saturationTemperature(pressure) {
    if (pressure <= 0) return null;
    return bisect(saturationPressure, pressure, minSaturationTemperature, maxTemperature);
  }
  function ratioFromPressure(vapourPressure, pressure) {
    return molecularRatio * vapourPressure / (pressure - vapourPressure);
  }
  function pressureFromRatio(ratio, pressure) {
    return pressure * (ratio / (molecularRatio + ratio));
  }
  function vapourEnthalpy(temperature) {
    return vapourReferenceEnthalpy + vapourHeatCapacity * temperature;
  }
  function enthalpy(temperature, ratio) {
    return dryAirHeatCapacity * temperature + ratio * vapourEnthalpy(temperature);
  }
  function volume(temperature, ratio, pressure) {
    return dryAirGasConstant * (temperature + 273.15) * (1 + ratio / molecularRatio) / pressure;
  }
  function relativeHumidity(temperature, ratio, pressure) {
    return 100 * pressureFromRatio(ratio, pressure) / saturationPressure(temperature);
  }
  function validateInput(key, value, pressure) {
    const label = properties[key].label;
    if (!Number.isFinite(value)) throw new Error("Enter a number for " + label.toLowerCase() + ".");
    if (key === "tdb" || key === "tdp" || key === "twb") {
      const minimum = key === "tdb" ? minDryBulb : minSaturationTemperature;
      if (value < minimum || value > maxTemperature) {
        throw new Error(label + " must be between " + minimum + " and " + maxTemperature + " °C.");
      }
    }
    if (key === "rh" && (value < 0 || value > 100)) {
      throw new Error("Relative humidity must be between 0 and 100%.");
    }
    if (key === "q" && (value < 0 || value >= 1)) {
      throw new Error("Specific humidity must be at least 0 and less than 1 kg water/kg moist air.");
    }
    if (key === "v" && value <= 0) throw new Error("Specific volume must be positive.");
    if (key === "pw" && (value < 0 || value >= pressure)) {
      throw new Error("Vapour pressure must be at least 0 and below total pressure.");
    }
  }
  function moistureRatio(key, value, pressure) {
    if (key === "q") return value / (1 - value);
    const vapourPressure = key === "tdp" ? saturationPressure(value) : value;
    if (vapourPressure >= pressure) {
      throw new Error("The dew point implies a vapour pressure at or above total pressure.");
    }
    return ratioFromPressure(vapourPressure, pressure);
  }
  function moistureProperty(key, ratio, pressure) {
    if (key === "q") return ratio / (1 + ratio);
    const vapourPressure = pressureFromRatio(ratio, pressure);
    return key === "pw" ? vapourPressure : saturationTemperature(vapourPressure);
  }
  function convertMoisture(from, value, to, air = 0) {
    if (!moistureKeys.includes(from) || !moistureKeys.includes(to)) {
      throw new Error("Choose a humidity, vapour pressure, or dew point conversion.");
    }
    const pressure = totalPressure(air);
    if (from === "pw" && to === "tdp") {
      if (!Number.isFinite(value) || value < 0) throw new Error("Vapour pressure must be a finite, nonnegative number.");
      return saturationTemperature(value);
    }
    validateInput(from, value, pressure);
    if (from === "tdp" && to === "pw") return saturationPressure(value);
    return moistureProperty(to, moistureRatio(from, value, pressure), pressure);
  }
  function expectMoistureReading(first, firstValue, second, secondValue, air) {
    const pressure = totalPressure(air);
    for (const [key, value] of [[first, firstValue], [second, secondValue]]) {
      validateInput(key, value, pressure);
      if (key === "tdp") moistureRatio(key, value, pressure);
    }
    return convertMoisture(first, firstValue, second, air);
  }
  function wetBulbCurve(wetBulb, pressure, useIce = wetBulb < 0) {
    const saturatedVapourPressure = saturationPressure(wetBulb);
    if (saturatedVapourPressure >= pressure) return null;
    const saturatedRatio = ratioFromPressure(saturatedVapourPressure, pressure);
    const saturatedEnthalpy = enthalpy(wetBulb, saturatedRatio);
    const waterEnthalpy = useIce ? -333.6 + 2.1 * wetBulb : 4.186 * wetBulb;
    const dryEnthalpy = saturatedEnthalpy - saturatedRatio * waterEnthalpy;
    return {
      waterEnthalpy,
      dryEnthalpy,
      dryBulbFromRatio(ratio) {
        return (dryEnthalpy - ratio * (vapourReferenceEnthalpy - waterEnthalpy)) / (dryAirHeatCapacity + vapourHeatCapacity * ratio);
      },
      ratioFromDryBulb(temperature) {
        return (dryEnthalpy - dryAirHeatCapacity * temperature) / (vapourEnthalpy(temperature) - waterEnthalpy);
      }
    };
  }
  function liquidOrIceBulb(temperature, ratio, pressure) {
    let upper = temperature;
    if (saturationPressure(upper) >= pressure) {
      upper = saturationTemperature(pressure * (1 - 1e-10));
    }
    if (upper === null) return null;
    if (upper >= 0) {
      const liquid = bisect((t) => wetBulbCurve(t, pressure, false).ratioFromDryBulb(temperature), ratio, 0, upper);
      if (liquid !== null) return liquid;
    }
    return bisect(
      (t) => wetBulbCurve(t, pressure, true).ratioFromDryBulb(temperature),
      ratio,
      minSaturationTemperature,
      Math.min(0, upper)
    );
  }
  function pairWithKnownTemperature(temperature, key, value, pressure) {
    if (moistureKeys.includes(key)) return moistureRatio(key, value, pressure);
    switch (key) {
      case "rh": {
        const vapourPressure = value * saturationPressure(temperature) / 100;
        if (vapourPressure >= pressure) throw new Error("These inputs imply vapour pressure at or above total pressure.");
        return ratioFromPressure(vapourPressure, pressure);
      }
      case "h":
        return (value - dryAirHeatCapacity * temperature) / vapourEnthalpy(temperature);
      case "v":
        return molecularRatio * (value / volume(temperature, 0, pressure) - 1);
      case "twb": {
        if (value > temperature) throw new Error("Wet bulb temperature cannot exceed dry bulb temperature.");
        return wetBulbCurve(value, pressure)?.ratioFromDryBulb(temperature);
      }
    }
  }
  function pairWithKnownMoisture(key, value, ratio, pressure) {
    switch (key) {
      case "rh": {
        if (value === 0 && ratio === 0) throw new Error("Zero moisture and 0% relative humidity do not determine dry bulb temperature.");
        return saturationTemperature(100 * pressureFromRatio(ratio, pressure) / value);
      }
      case "h":
        return (value - vapourReferenceEnthalpy * ratio) / (dryAirHeatCapacity + vapourHeatCapacity * ratio);
      case "v":
        return value * pressure / (dryAirGasConstant * (1 + ratio / molecularRatio)) - 273.15;
      case "twb":
        return wetBulbCurve(value, pressure)?.dryBulbFromRatio(ratio);
    }
  }
  function pairWithWetBulb(wetBulb, key, value, pressure) {
    const curve = wetBulbCurve(wetBulb, pressure);
    if (!curve) return [null, null];
    if (key === "h") {
      if (curve.waterEnthalpy === 0) {
        throw new Error("Enthalpy and a wet bulb of exactly 0 °C cannot determine a unique state. Use another input property.");
      }
      const ratio = (value - curve.dryEnthalpy) / curve.waterEnthalpy;
      return [curve.dryBulbFromRatio(ratio), ratio];
    }
    const fn = key === "rh" ? relativeHumidity : volume;
    const dryBulb = bisect(
      (t) => fn(t, curve.ratioFromDryBulb(t), pressure),
      value,
      Math.max(wetBulb, minDryBulb),
      Math.min(curve.dryBulbFromRatio(0), maxTemperature)
    );
    return dryBulb === null ? [null, null] : [dryBulb, curve.ratioFromDryBulb(dryBulb)];
  }
  function pairWithoutTemperatures(first, firstValue, second, secondValue, pressure) {
    if (first === "rh" || second === "rh") {
      const hasRelativeHumidityFirst = first === "rh";
      const fraction = (hasRelativeHumidityFirst ? firstValue : secondValue) / 100;
      const target = hasRelativeHumidityFirst ? secondValue : firstValue;
      const fn = (hasRelativeHumidityFirst ? second : first) === "h" ? enthalpy : volume;
      const fromTemperature2 = (temperature3) => ratioFromPressure(fraction * saturationPressure(temperature3), pressure);
      let upper = maxTemperature;
      if (fraction * saturationPressure(upper) >= pressure) {
        upper = saturationTemperature(pressure * (1 - 1e-10) / fraction);
      }
      if (upper === null) return [null, null];
      const temperature2 = bisect((t) => fn(t, fromTemperature2(t), pressure), target, minDryBulb, upper);
      return temperature2 === null ? [null, null] : [temperature2, fromTemperature2(temperature2)];
    }
    const knownEnthalpy = first === "h" ? firstValue : secondValue;
    const knownVolume = first === "v" ? firstValue : secondValue;
    const fromTemperature = (temperature2) => molecularRatio * (knownVolume / volume(temperature2, 0, pressure) - 1);
    const temperature = bisect((t) => enthalpy(t, fromTemperature(t)), knownEnthalpy, minDryBulb, maxTemperature);
    return temperature === null ? [null, null] : [temperature, fromTemperature(temperature)];
  }
  function solveState(first, firstValue, second, secondValue, air = 0) {
    if (!catalogInputs.includes(first) || !catalogInputs.includes(second)) {
      throw new Error("Choose a property in each column.");
    }
    const pressure = totalPressure(air);
    validateInput(first, firstValue, pressure);
    validateInput(second, secondValue, pressure);
    if (first === second) {
      const explanation = firstValue === secondValue ? "Both columns give the same " + properties[first].label + "." : "The two " + properties[first].label + " readings disagree.";
      throw new Error(explanation + " Choose two different properties to determine the air state.");
    }
    if (!independent(first, second)) {
      throw new Error(properties[first].label + " and " + properties[second].label + " give the same moisture information at this pressure. Choose another property, such as Dry Bulb Temperature.");
    }
    const known = { [first]: firstValue, [second]: secondValue };
    let temperature;
    let ratio;
    const otherThan = (key) => key === first ? second : first;
    const moistureKey = moistureKeys.find((key) => key in known);
    if ("tdb" in known) {
      temperature = known.tdb;
      const other = otherThan("tdb");
      ratio = pairWithKnownTemperature(temperature, other, known[other], pressure);
    } else if (moistureKey) {
      ratio = moistureRatio(moistureKey, known[moistureKey], pressure);
      const other = otherThan(moistureKey);
      temperature = pairWithKnownMoisture(other, known[other], ratio, pressure);
    } else if ("twb" in known) {
      const other = otherThan("twb");
      [temperature, ratio] = pairWithWetBulb(known.twb, other, known[other], pressure);
    } else {
      [temperature, ratio] = pairWithoutTemperatures(first, firstValue, second, secondValue, pressure);
    }
    if (!(Number.isFinite(temperature) && Number.isFinite(ratio)) || temperature < minDryBulb - 1e-8 || temperature > maxTemperature + 1e-8 || ratio < -1e-10) {
      throw new Error("These inputs do not describe a moist-air state within the supported range.");
    }
    temperature = Math.min(maxTemperature, Math.max(minDryBulb, temperature));
    ratio = Math.max(0, ratio);
    const vp = pressureFromRatio(ratio, pressure);
    const saturation = saturationPressure(temperature);
    if (vp >= pressure || vp > saturation * (1 + 1e-8)) {
      throw new Error("The inputs give a supersaturated state or vapour pressure at or above total pressure.");
    }
    if ("twb" in known && known.twb > temperature + 1e-8) {
      throw new Error("Wet bulb temperature cannot exceed dry bulb temperature.");
    }
    const state = {
      tdb: temperature,
      q: ratio / (1 + ratio),
      rh: Math.min(100, 100 * vp / saturation),
      h: enthalpy(temperature, ratio),
      twb: known.twb ?? liquidOrIceBulb(temperature, ratio, pressure),
      v: volume(temperature, ratio, pressure),
      pw: vp,
      tdp: known.tdp ?? saturationTemperature(vp),
      p: pressure
    };
    if (Object.values(state).some((value) => value !== null && !Number.isFinite(value))) {
      throw new Error("These inputs exceed the numerical range of the calculator.");
    }
    return state;
  }
  function formatProperty(key, value) {
    if (value === null) return "Unavailable";
    let digits = 2;
    if (key === "q") digits = 7;
    if (key === "p") digits = 6;
    if (key === "v" || key === "pw") digits = 5;
    if (value !== 0 && Math.abs(value) < 10 ** -digits) return value.toExponential(3);
    return value.toFixed(digits);
  }

  // src/shared/dom.mjs
  function readNumber(input) {
    return input.value.trim() === "" ? NaN : Number(input.value);
  }
  function setStatus(element, message = "", isError = false) {
    element.textContent = message;
    element.classList.toggle("error", isError);
  }

  // src/shared/history.mjs
  var databaseName = "aditusan-calculation-history";
  var database;
  function openDatabase() {
    database ??= new Promise((resolve, reject) => {
      const request = indexedDB.open(databaseName, 1);
      request.onupgradeneeded = () => {
        const db = request.result;
        const records = db.createObjectStore("records", { keyPath: "id", autoIncrement: true });
        records.createIndex("scope", "scope");
        db.createObjectStore("snapshots");
      };
      request.onsuccess = () => resolve(request.result);
      request.onerror = () => reject(request.error);
      request.onblocked = () => reject(new Error("Calculation history storage is blocked."));
    });
    return database;
  }
  function resultOf(request) {
    return new Promise((resolve, reject) => {
      request.onsuccess = () => resolve(request.result);
      request.onerror = () => reject(request.error);
    });
  }
  async function changeHistory(scope, update) {
    const db = await openDatabase();
    return new Promise((resolve, reject) => {
      const transaction = db.transaction(["records", "snapshots"], "readwrite");
      transaction.oncomplete = resolve;
      transaction.onabort = () => reject(transaction.error ?? new Error("History storage is unavailable."));
      const records = transaction.objectStore("records");
      const snapshots = transaction.objectStore("snapshots");
      const matches = records.index("scope").getAll(scope);
      matches.onsuccess = () => update(matches.result, records, snapshots);
    });
  }
  function createHistory(id, { label = "Restore", action, limit = 20 } = {}) {
    const panel = document.getElementById(id);
    const list = panel.querySelector(".history-list");
    const empty = panel.querySelector(".history-empty");
    const clear2 = panel.querySelector(".history-clear");
    const note = panel.querySelector(".history-message");
    const scope = location.pathname.replace(/index\.html$/, "").replace(/\/?$/, "/") + "#" + id;
    const byteLimit = 96 * 1024 * 1024;
    let pending = Promise.resolve();
    let temporary;
    function render(entries) {
      list.replaceChildren();
      empty.hidden = entries.length > 0;
      clear2.disabled = entries.length === 0;
      for (const entry of entries) {
        const row = document.createElement("li");
        const description = document.createElement("span");
        description.textContent = entry.summary;
        const when = document.createElement("small");
        when.className = "history-time";
        when.textContent = new Date(entry.time).toLocaleString(void 0, { dateStyle: "short", timeStyle: "short" });
        description.append(when);
        const button = document.createElement("button");
        button.type = "button";
        button.textContent = label;
        button.setAttribute("aria-label", label + " " + entry.summary);
        button.addEventListener("click", async () => {
          try {
            const snapshot = entry.id === null ? structuredClone(temporary.snapshot) : await resultOf((await openDatabase()).transaction("snapshots").objectStore("snapshots").get(entry.id));
            if (!snapshot) throw new Error("That calculation was cleared.");
            await action(snapshot);
          } catch (error) {
            note.textContent = error.message;
          }
        });
        row.append(description, button);
        list.append(row);
      }
    }
    async function refresh() {
      let entries = [];
      try {
        const db = await openDatabase();
        entries = await resultOf(db.transaction("records").objectStore("records").index("scope").getAll(scope));
      } catch {
        note.textContent = "Saved history is unavailable in this browser.";
      }
      entries.reverse();
      if (temporary) entries.unshift(temporary.record);
      render(entries);
    }
    clear2.addEventListener("click", () => {
      pending = pending.then(async () => {
        try {
          await changeHistory(scope, (entries, records, snapshots) => {
            for (const entry of entries) {
              records.delete(entry.id);
              snapshots.delete(entry.id);
            }
          });
          temporary = void 0;
          note.textContent = "History cleared.";
        } catch {
          if (temporary) {
            temporary = void 0;
            note.textContent = "Temporary history cleared.";
          } else {
            note.textContent = "The browser could not clear saved history.";
          }
        }
        await refresh();
      });
    });
    pending = refresh();
    return {
      add(summary, snapshot, bytes = 0) {
        const record = { scope, summary, time: Date.now(), bytes };
        pending = pending.then(async () => {
          try {
            await changeHistory(scope, (entries, records, snapshots) => {
              let keep = 1;
              let usedBytes = bytes;
              for (const entry of entries.reverse()) {
                if (keep >= limit || usedBytes + entry.bytes > byteLimit) {
                  records.delete(entry.id);
                  snapshots.delete(entry.id);
                } else {
                  keep++;
                  usedBytes += entry.bytes;
                }
              }
              const insert = records.add(record);
              insert.onsuccess = () => snapshots.add(snapshot, insert.result);
            });
            temporary = void 0;
            note.textContent = "";
          } catch {
            temporary = { record: { ...record, id: null }, snapshot };
            note.textContent = "The browser could not save this run. It is available until you close or reload this page.";
          }
          await refresh();
        });
      }
    };
  }

  // src/psychrometrics/calculator.mjs
  var form = document.querySelector("#psych-form");
  var results = [...document.querySelectorAll("[data-property]")];
  var status = document.querySelector("#psych-status");
  var selects = [document.querySelector("#first-property"), document.querySelector("#second-property")];
  var fields = [...form.querySelectorAll("[data-input-slot]")];
  var airFields = {
    altitude: form.elements.altitude,
    pressure: form.elements.pressure
  };
  var airMode = form.elements.pressureMode;
  var history = createHistory("psych-history", { action: restore });
  var kind = form.dataset.kind;
  function selectedKey(slot) {
    return selects[slot]?.value ?? (slot === 0 ? form.dataset.first : form.dataset.second);
  }
  function updateLabel(slot) {
    const property = properties[selectedKey(slot)];
    fields[slot].querySelector(".input-name").textContent = property.label;
    fields[slot].querySelector(".input-unit").textContent = property.unit;
  }
  function updateAirMode() {
    const active = airMode.value;
    for (const [mode, input] of Object.entries(airFields)) {
      input.disabled = mode !== active;
      input.closest(".field").hidden = mode !== active;
    }
    for (const panel of document.querySelectorAll("[data-air-result]")) {
      panel.hidden = panel.dataset.airResult !== active;
    }
  }
  function clear() {
    for (const result of results) result.textContent = "—";
    setStatus(status);
  }
  for (const [slot, select] of selects.entries()) {
    select?.addEventListener("change", () => {
      fields[slot].querySelector("input").value = "";
      updateLabel(slot);
      clear();
    });
  }
  form.addEventListener("change", (event) => {
    if (event.target.name === "pressureMode") updateAirMode();
  });
  function restore(saved) {
    if (selects[0]) {
      selects[0].value = saved.first;
      selects[1].value = saved.second;
    }
    saved.inputs.forEach((input, slot) => {
      let value = input;
      if (typeof input === "object") {
        value = input.value;
        if (selectedKey(slot) === "q" && input.basis === "w" && value !== "") {
          const ratio = Number(value);
          value = ratio / (1 + ratio);
        }
      }
      updateLabel(slot);
      fields[slot].querySelector("input").value = value;
    });
    const air = saved.air ?? { mode: "altitude", value: saved.altitude ?? 0 };
    airMode.value = air.mode;
    airFields[air.mode].value = air.value;
    updateAirMode();
    evaluate();
  }
  function evaluate(save = false) {
    clear();
    try {
      const mode = airMode.value;
      const air = { mode, value: readNumber(airFields[mode]) };
      const first = selectedKey(0);
      const second = selectedKey(1);
      const inputs = fields.map((field) => field.querySelector("input").value);
      const [firstValue, secondValue] = fields.map((field) => readNumber(field.querySelector("input")));
      let target = form.dataset.target || "h";
      let state;
      let message = "Calculation complete.";
      if (kind === "pressure") {
        target = mode === "altitude" ? "p" : "z";
        state = { [target]: mode === "altitude" ? atmosphericPressure(air.value) : altitudeFromPressure(air.value) };
      } else if (kind === "moisture") {
        state = { [target]: convertMoisture(first, firstValue, target, air) };
      } else if (kind === "check") {
        target = second;
        state = { [target]: expectMoistureReading(first, firstValue, second, secondValue, air) };
        message = "Entered " + properties[target].label + " was " + formatProperty(target, secondValue) + " " + properties[target].unit + ". A full state needs an independent input.";
      } else {
        state = solveState(first, firstValue, second, secondValue, air);
      }
      for (const result of results) {
        const key = result.dataset.property;
        if (Object.hasOwn(state, key)) result.textContent = formatProperty(key, state[key]);
      }
      if (state.tdp === null && results.some((result) => result.dataset.property === "tdp")) {
        message = "The dew point is undefined for dry air or below the supported range of −100 °C.";
      } else if (state.twb === null && results.some((result) => result.dataset.property === "twb")) {
        message = "A wet bulb temperature could not be found in the supported range.";
      }
      setStatus(status, message);
      if (save) {
        const inputText = inputs.map((value, slot) => value + " " + properties[selectedKey(slot)].symbol);
        const airText = air.value + (mode === "altitude" ? " m" : " kPa");
        const resultText = properties[target].label + " " + formatProperty(target, state[target]) + (state[target] === null ? "" : " " + properties[target].unit);
        history.add([...inputText, airText, resultText].join(" · "), { first, second, inputs, air, state });
      }
    } catch (error) {
      setStatus(status, error.message, true);
    }
  }
  form.addEventListener("submit", (event) => {
    event.preventDefault();
    evaluate(true);
  });
  form.addEventListener("input", clear);
  for (const button of document.querySelectorAll("[data-psych-example]")) {
    button.addEventListener("click", () => {
      const { values, air, first = selectedKey(0), second = selectedKey(1) } = JSON.parse(button.dataset.psychExample);
      restore({ first, second, air, inputs: values });
      form.querySelector("button[type=submit]").focus();
    });
    button.disabled = false;
  }
  updateAirMode();
  form.querySelector("button[type=submit]").disabled = false;
  setStatus(status);
  var search = document.querySelector("#conversion-search");
  if (search) {
    const groups = [...document.querySelectorAll("#conversion-list details")];
    const searchStatus = document.querySelector("#conversion-count");
    const normalise = (text) => text.toLowerCase().replace(/\bvapor\b/g, "vapour").replace(/[-–]/g, " ");
    search.addEventListener("input", () => {
      const words = normalise(search.value).split(/\s+/).filter(Boolean);
      let count = 0;
      for (const group of groups) {
        let hasMatch = false;
        const summary = group.querySelector("summary").textContent;
        for (const li of group.querySelectorAll("li")) {
          const title = normalise(summary + " " + li.textContent);
          const matches = words.every((word) => title.includes(word));
          li.hidden = !matches;
          hasMatch ||= matches;
          count += Number(matches);
        }
        group.hidden = !hasMatch;
        if (words.length) group.open = hasMatch;
        else group.open = group.hasAttribute("data-open");
      }
      searchStatus.textContent = words.length ? count + (count === 1 ? " matching calculation" : " matching calculations") : "";
    });
  }
})();
