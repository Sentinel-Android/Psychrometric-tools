function psychrometry1()
    while true
        format long;
        fprintf('Psychrometry what?\n');
        fprintf('1. Psychrometric Calculator\n2. 3D Graph\n3. Full Graph\n');
        choice=input('Which feature you want to use?');
        if(choice==1)
            psychrometric_calculator();
        end
        if(choice==2)
            graph3D();
        end
        if(choice==3)
            graph_full();
        end
        choice=input('Do you want to perform another calculation? (y/n): ','s');
        if strcmpi(choice,'n')
            disp('Exiting the program.');
            break;
        end
    end
end

function psychrometric_calculator()
    fprintf('Enter any two Psychrometric properties from the list in increasing order of their number:');
    fprintf('1. Dry bulb temperature(in degree celcius)\n2. Specific humidity(in kg/kg)\n3. Relative humidity(in percentage)\n4. Enthalpy(in kj/kg)\n5. Wet bulb temperature(in degree celcius)\n6. Specific volume(in m3/kg)\n7. Vapour pressure(in pa)\n8. Dew point temperature(in degree celcius)\n9. Thermodynamic wet bulb temperature(in degree celcius)\n');
    p=input('Enter the first value:');
    q=input('Enter the second value:');
    if(p==1)
        if(q==2)
            db_sh;
        end
        if(q==3)
            db_rh;
        end
        if(q==4)
                db_et;
        end
        if(q==5)
            db_wb;
        end
        if(q==6)
            db_sv;
        end
        if(q==7)
            db_pv;
        end
        if(q==8)
            db_dp;
        end
    end
    if(p==2)
        if(q==3)
            sh_rh;
        end
        if(q==4)
            sh_et;
        end
        if(q==5)
            sh_wb;
        end
        if(q==6)
            sh_sv;
        end
        if(q==7)
            fprintf('Invalid choice. Try again.');
        end
        if(q==8)
            fprintf('Invalid choice. Try again.');
        end
    end
    if(p==3)
        if(q==4)
            rh_et;
        end
        if(q==5)
            rh_wb;
        end
        if(q==6)
            rh_sv;
        end
        if(q==7)
           rh_pv;
        end
        if(q==8)
            rh_dp;
        end
    end
    if(p==4)
        if(q==5)
            fprintf('Invalid choice. Try again.');
        end
        if(q==6)
            et_sv;
        end
        if(q==7)
            et_pv;
        end
        if(q==8)
            et_dp;
        end
    end
    if(p==5)
        if(q==6)
            wb_sv;
        end
        if(q==7)
            wb_pv;
        end
        if(q==8)
            wb_dp;
        end
    end
    if(p==6)
        if(q==7)
            sv_pv;
        end
        if(q==8)
            sv_dp;
        end
    end
    if(p==7)
        if(q==8)
            fprintf('Invalid choice. Try again.');
        end
    end
end

function db_sh
    H=input('Enter height from sea level(in m)');
    PT=101.325*((1-(2.25577*(10^(-5))*H))^5.2559); %in kpa
    DB=input('Enter Dry Bulb Temperature(in degree celcius)\n');
    SH=input('Enter Specific Humidity(in kg/kg)\n');
    ET=(1.005*DB)+SH*(2500+(1.88*DB)) %in kj/kg
    PV=PT/((0.622/SH)+1) %in kpa
    DP=getSaturationTemperature(PV)
    PS=getSaturationPressure(DB);
    RH=(PV/PS)*100 %in percentage
    SV=0.2871*(DB+273.15)/(PT-PV) %in m3/kg
    WB=-4.391976+(0.0198197*RH)+(0.526359*DB)+(0.00730271*RH*DB)+(2.4315*(10^(-4))*(RH^(2)))-(2.58101*(10^(-5))*DB*(RH^(2)))
    graph2D(PT,ET,PV,RH,SV,WB);
end

function db_rh
    H=input('Enter height from sea level(in m)');
    PT=101.325*((1-(2.25577*(10^(-5))*H))^5.2559); %in kpa
    DB=input('Enter Dry Bulb Temperature(in degree celcius)\n');
    RH=input('Enter Relative humidity(in percentage)\n');
    PS=getSaturationPressure(DB);
    PV=(RH*PS)/100 %in kpa
    SV=0.2871*(DB+273.15)/(PT-PV) %in m3/kg
    SH=0.622*(PV/(PT-PV)) %in kg/kg
    ET=(1.005*DB)+SH*(2500+(1.88*DB)) %in kj/kg
    DP=getSaturationTemperature(PV)
    WB=-4.391976+(0.0198197*RH)+(0.526359*DB)+(0.00730271*RH*DB)+(2.4315*(10^(-4))*(RH^(2)))-(2.58101*(10^(-5))*DB*(RH^(2)))
    graph2D(PT,ET,PV,RH,SV,WB);
end

function db_et
    H=input('Enter height from sea level(in m)');
    PT=101.325*((1-(2.25577*(10^(-5))*H))^5.2559); %in kpa
    DB=input('Enter Dry Bulb Temperature(in degree celcius)\n');
    ET=input('Enter Enthalpy(in kj/kg)\n');
    PS=getSaturationPressure(DB);
    SH=(ET-(1.005*DB))/(2500+(1.88*DB)) %in kg/kg
    PV=PT/((0.622/SH)+1) %in kpa
    DP=getSaturationTemperature(PV)
    RH=(PV/PS)*100 %in percentage
    SV=0.2871*(DB+273.15)/(PT-PV) %in m3/kg
    WB=-4.391976+(0.0198197*RH)+(0.526359*DB)+(0.00730271*RH*DB)+(2.4315*(10^(-4))*(RH^(2)))-(2.58101*(10^(-5))*DB*(RH^(2)))
    graph2D(PT,ET,PV,RH,SV,WB);
end

function db_wb
    H=input('Enter height from sea level(in m)');
    PT=101.325*((1-(2.25577*(10^(-5))*H))^5.2559); %in kpa
    DB=input('Enter Dry Bulb Temperature(in degree celcius)\n');
    WB=input('Enter Wet Bulb Temperature(in degree celcius)\n');
    PS=getSaturationPressure(DB);
    PSWET=getSaturationPressure(WB)
    P=PT*((DB-WB)/1514)*(1+(WB/873));
    RH=((PSWET-P)/PS)*100 %in percentage
    PV=(RH*PS)/100 %in kpa
    SV=0.2871*(DB+273.15)/(PT-PV) %in m3/kg
    SH=0.622*(PV/(PT-PV)) %in kg/kg
    ET=(1.005*DB)+SH*(2500+(1.88*DB)) %in kj/kg
    DP=getSaturationTemperature(PV)
    graph2D(PT,ET,PV,RH,SV,WB);
end

function db_sv
    H=input('Enter height from sea level(in m)');
    PT=101.325*((1-(2.25577*(10^(-5))*H))^5.2559); %in kpa
    DB=input('Enter Dry Bulb Temperature\n');
    SV=input('Enter Specific Volume\n');
    PS=getSaturationPressure(DB);
    PV=PT-(0.2871*(DB+273.15)/SV) %in kpa
    SH=0.622*(PV/(PT-PV)) %in kg/kg
    ET=(1.005*DB)+SH*(2500+(1.88*DB)) %in kj/kg
    DP=getSaturationTemperature(PV)
    RH=(PV/PS)*100 %in percentage
    WB=-4.391976+(0.0198197*RH)+(0.526359*DB)+(0.00730271*RH*DB)+(2.4315*(10^(-4))*(RH^(2)))-(2.58101*(10^(-5))*DB*(RH^(2)))
    graph2D(PT,ET,PV,RH,SV,WB);
end

function db_pv
    H=input('Enter height from sea level(in m)');
    PT=101.325*((1-(2.25577*(10^(-5))*H))^5.2559); %in kpa
    DB=input('Enter Dry Bulb Temperature\n');
    PV=input('Enter Vapour Pressure\n');
    PS=getSaturationPressure(DB);
    RH=(PV/PS)*100 %in percentage
    SH=0.622*(PV/(PT-PV)) %in kg/kg
    ET=(1.005*DB)+SH*(2500+(1.88*DB)) %in kj/kg
    DP=getSaturationTemperature(PV)
    SV=0.2871*(DB+273.15)/(PT-PV) %in m3/kg
    WB=-4.391976+(0.0198197*RH)+(0.526359*DB)+(0.00730271*RH*DB)+(2.4315*(10^(-4))*(RH^(2)))-(2.58101*(10^(-5))*DB*(RH^(2)))
    graph2D(PT,ET,PV,RH,SV,WB);
end

function db_dp
    H=input('Enter height from sea level(in m)');
    PT=101.325*((1-(2.25577*(10^(-5))*H))^5.2559); %in kpa
    DB=input('Enter Dry Bulb Temperature\n');
    DP=input('Enter Dew Point Temperature\n');
    PS=getSaturationPressure(DB);
    PV=getSaturationPressure(DP)
    SH=0.622*(PV/(PT-PV)) %in kg/kg
    RH=(PV/PS)*100 %in percentage
    ET=(1.005*DB)+SH*(2500+(1.88*DB)) %in kj/kg
    SV=0.2871*(DB+273.15)/(PT-PV) %in m3/kg
    WB=-4.391976+(0.0198197*RH)+(0.526359*DB)+(0.00730271*RH*DB)+(2.4315*(10^(-4))*(RH^(2)))-(2.58101*(10^(-5))*DB*(RH^(2)))
    graph2D(PT,ET,PV,RH,SV,WB);
end

function sh_rh
    H=input('Enter height from sea level(in m)');
    PT=101.325*((1-(2.25577*(10^(-5))*H))^5.2559); %in kpa
    SH=input('Enter Specific Humidity\n');
    RH=input('Enter Relative Humidity\n');
    PV=PT/((0.622/SH)+1) %in kpa
    PS=(PV/RH)*100;
    DB=getSaturationTemperature(PS)
    ET=(1.005*DB)+SH*(2500+(1.88*DB)) %in kj/kg
    DP=getSaturationTemperature(PV)
    SV=0.2871*(DB+273.15)/(PT-PV) %in m3/kg
    WB=-4.391976+(0.0198197*RH)+(0.526359*DB)+(0.00730271*RH*DB)+(2.4315*(10^(-4))*(RH^(2)))-(2.58101*(10^(-5))*DB*(RH^(2)))
    graph2D(PT,ET,PV,RH,SV,WB);
end

function sh_et
    H=input('Enter height from sea level(in m)');
    PT=101.325*((1-(2.25577*(10^(-5))*H))^5.2559); %in kpa
    SH=input('Enter Specific Humidity\n');
    ET=input('Enter Enthalpy\n');
    PV=PT/((0.622/SH)+1) %in kpa
    DP=getSaturationTemperature(PV)
    DB=(ET-(2500*SH))/(1.005+(1.88*SH))
    PS=getSaturationPressure(DB);
    RH=(PV/PS)*100 %in percentage
    SV=0.2871*(DB+273.15)/(PT-PV) %in m3/kg
    WB=-4.391976+(0.0198197*RH)+(0.526359*DB)+(0.00730271*RH*DB)+(2.4315*(10^(-4))*(RH^(2)))-(2.58101*(10^(-5))*DB*(RH^(2)))
    graph2D(PT,ET,PV,RH,SV,WB);
end

function sh_wb
    H=input('Enter height from sea level(in m)');
    PT=101.325*((1-(2.25577*(10^(-5))*H))^5.2559); %in kpa
    SH=input('Enter Specific Humidity\n');
    WB=input('Enter Wet Bulb Temperature\n');
    PV=PT/((0.622/SH)+1) %in kpa
    DP=getSaturationTemperature(PV)
    PSWET=getSaturationPressure(WB)
    DB=WB+((PSWET-PV)/(PT*0.00066)) %in degree celcius close value
    PS=getSaturationPressure(DB);
    RH=(PV/PS)*100 %in percentage
    ET=(1.005*DB)+SH*(2500+(1.88*DB)) %in kj/kg
    SV=0.2871*(DB+273.15)/(PT-PV) %in m3/kg
    graph2D(PT,ET,PV,RH,SV,WB);
end

function sh_sv
    H=input('Enter height from sea level(in m)');
    PT=101.325*((1-(2.25577*(10^(-5))*H))^5.2559); %in kpa
    SH=input('Enter Specific Humidity\n');
    SV=input('Enter Specific Volume\n');
    PV=PT/((0.622/SH)+1) %in kpa
    DP=getSaturationTemperature(PV)
    DB=(SV*(PT-PV)/0.2871)-273.15
    PS=getSaturationPressure(DB);
    ET=(1.005*DB)+SH*(2500+(1.88*DB)) %in kj/kg
    RH=(PV/PS)*100 %in percentage
    WB=-4.391976+(0.0198197*RH)+(0.526359*DB)+(0.00730271*RH*DB)+(2.4315*(10^(-4))*(RH^(2)))-(2.58101*(10^(-5))*DB*(RH^(2)))
    graph2D(PT,ET,PV,RH,SV,WB);
end

function rh_et
    H=input('Enter height from sea level(in m)');
    PT=101.325*((1-(2.25577*(10^(-5))*H))^5.2559); %in kpa
    RH=input('Enter Relative Humidity\n');
    ET=input('Enter Enthalpy\n');
    RH_given = RH;
    ET_given = ET;
    PC = 22100;
    TC = 647.30;
    tolerance = 1e-6;
    DB = 25;
    max_iter = 1000;
    for iter = 1:max_iter
        T_k = DB + 273.15;
        K = 4.39553 - 6.2442 * (T_k / 1000) + 9.953 * (T_k / 1000)^2 - 5.151 * (T_k / 1000)^3;
        PS = PC * (10^(K * (1 - TC / T_k)));
        PV = (RH_given / 100) * PS;
        SH = 0.622 * (PV / (PT - PV));
        ET_calculated = 1.005 * DB + SH * (2500 + 1.88 * DB);
        if abs(ET_calculated - ET_given) < tolerance
            break;
        end
        DB = DB - 0.1 * (ET_calculated - ET_given);
    end
    if iter < max_iter
        fprintf('Converged to DB = %.4f°C in %d iterations.\n', DB, iter);
    else
        fprintf('Did not converge within the maximum number of iterations.\n');
    end
    SH=(ET-(1.005*DB))/(2500+(1.88*DB)) %in kg/kg
    WB=-4.391976+(0.0198197*RH)+(0.526359*DB)+(0.00730271*RH*DB)+(2.4315*(10^(-4))*(RH^(2)))-(2.58101*(10^(-5))*DB*(RH^(2)))
    PV=PT/((0.622/SH)+1) %in kpa
    DP=getSaturationTemperature(PV)
    SV=0.2871*(DB+273.15)/(PT-PV) %in m3/kg
    graph2D(PT,ET,PV,RH,SV,WB);
end

function rh_wb
    H=input('Enter height from sea level(in m)');
    PT=101.325*((1-(2.25577*(10^(-5))*H))^5.2559); %in kpa
    RH=input('Enter Relative Humidity\n');
    WB=input('Enter Wet Bulb Temperature\n');
    PC=22100;
    TC=647.30;
    compute_RH_diff = @(DB)RH - (((PC * 10^((4.39553 - 6.2442*((WB+273.15)/1000) ...
        + 9.953*(((WB+273.15)/1000)^2) - 5.151*(((WB+273.15)/1000)^3)) * (1 - (TC/(WB+273.15))))) ...
        - (PT * ((DB-WB)/1514)*(1 + (WB/873)))) / (PC * 10^((4.39553 - 6.2442*((DB+273.15)/1000) ...
        + 9.953*(((DB+273.15)/1000)^2) - 5.151*(((DB+273.15)/1000)^3)) * (1 - (TC/(DB+273.15))))) * 100);
    DB_min = -40;
    DB_max = 65;
    tol = 1e-6;
    max_iter = 100;
    for iter = 1:max_iter
        DB_mid = (DB_min + DB_max) / 2;
        RH_diff_mid = compute_RH_diff(DB_mid);
        if abs(RH_diff_mid) < tol
            fprintf('Solution converged after %d iterations.\n', iter);
            break;
        end
        if RH_diff_mid > 0
            DB_max = DB_mid;
        else
            DB_min = DB_mid;
        end
    end
    DB_solution = DB_mid;
    fprintf('The value of DB is: %f °C\n', DB_solution);
    DB=DB_solution;
    PS=getSaturationPressure(DB);
    PV=(RH*PS)/100 %in kpa
    SH=0.622*(PV/(PT-PV)) %in kg/kg
    ET=(1.005*DB)+SH*(2500+(1.88*DB)) %in kj/kg
    SV=0.2871*(DB+273.15)/(PT-PV) %in m3/kg
    DP=getSaturationTemperature(PV)
    graph2D(PT,ET,PV,RH,SV,WB);
end

function rh_sv
    H=input('Enter height from sea level(in m)');
    PT=101.325*((1-(2.25577*(10^(-5))*H))^5.2559); %in kpa
    RH=input('Enter Relative Humidity\n');
    SV=input('Enter Specific Volume\n');
    f = @(PS) SV - (0.2871 * (6.54 + (14.526*log(PS)) + (0.7389*(log(PS))^2) + (0.0949*(log(PS))^3) + (0.4569*(PS)^0.1984) + 273.15)/ (PT - (RH*PS/100)));
    df = @(PS) -(0.2871 * ((14.526/PS) + (2*0.7389*log(PS)/PS)+ (3*0.0949*(log(PS))^2/PS) + (0.4569*0.1984*(PS)^(-0.8016))) / (PT - (RH*PS/100)));
    PS_guess = 1;
    tol = 1e-6;
    max_iter = 1000000;
    for iter = 1:max_iter
        PS_new = PS_guess - f(PS_guess)/df(PS_guess);
        if abs(PS_new - PS_guess) < tol
            fprintf('Solution converged after %d iterations.\n', iter);
            break;
        end
        PS_guess = PS_new;
    end
    PS_solution = PS_new;
    fprintf('The value of PS is: %f\n', PS_solution);
    PS=PS_solution;
    DB=getSaturationTemperature(PS)
    PV=(RH*PS)/100 %in kpa
    DP=getSaturationTemperature(PV)
    SH=0.622*(PV/(PT-PV)) %in kg/kg
    ET=(1.005*DB)+SH*(2500+(1.88*DB)) %in kj/kg
    WB=-4.391976+(0.0198197*RH)+(0.526359*DB)+(0.00730271*RH*DB)+(2.4315*(10^(-4))*(RH^(2)))-(2.58101*(10^(-5))*DB*(RH^(2)))
    graph2D(PT,ET,PV,RH,SV,WB);
end

function rh_pv
    H=input('Enter height from sea level(in m)');
    PT=101.325*((1-(2.25577*(10^(-5))*H))^5.2559); %in kpa
    RH=input('Enter Relative Humidity\n');
    PV=input('Enter Vapour Pressure\n');
    PS=(PV/RH)*100;
    DB=getSaturationTemperature(PS)
    SH=0.622*(PV/(PT-PV)) %in kg/kg
    WB=-4.391976+(0.0198197*RH)+(0.526359*DB)+(0.00730271*RH*DB)+(2.4315*(10^(-4))*(RH^(2)))-(2.58101*(10^(-5))*DB*(RH^(2)))
    DP=getSaturationTemperature(PV)
    ET=(1.005*DB)+SH*(2500+(1.88*DB)) %in kj/kg
    SV=0.2871*(DB+273.15)/(PT-PV) %in m3/kg
    graph2D(PT,ET,PV,RH,SV,WB);
end

function rh_dp
    H=input('Enter height from sea level(in m)');
    PT=101.325*((1-(2.25577*(10^(-5))*H))^5.2559); %in kpa
    RH=input('Enter Relative Humidity\n');
    DP=input('Enter Dew Point Temperature\n');
    PV=getSaturationPressure(DP)
    PS=(PV/RH)*100;
    PS=(PV/RH)*100;
    DB=getSaturationTemperature(PS)
    SH=0.622*(PV/(PT-PV)) %in kg/kg
    WB=-4.391976+(0.0198197*RH)+(0.526359*DB)+(0.00730271*RH*DB)+(2.4315*(10^(-4))*(RH^(2)))-(2.58101*(10^(-5))*DB*(RH^(2)))
    ET=(1.005*DB)+SH*(2500+(1.88*DB)) %in kj/kg
    SV=0.2871*(DB+273.15)/(PT-PV) %in m3/kg
    graph2D(PT,ET,PV,RH,SV,WB);
end

function et_sv
    H=input('Enter height from sea level(in m)');
    PT=101.325*((1-(2.25577*(10^(-5))*H))^5.2559); %in kpa
    ET=input('Enter Enthalpy\n');
    SV=input('Enter Specific Volume\n');
    tol = 1e-6;
    max_iter = 100;
    DB_min = -40;
    DB_max = 65;
    function diff = compute_ET_diff(DB, ET, SV, PT)
        PV = PT - 0.2871 * (DB + 273.15) / SV;
        SH = 0.622 * (PV / (PT - PV));
        ET_calculated = (1.005 * DB) + SH * (2500 + (1.88 * DB));
        diff = ET_calculated - ET;
    end
    for iter = 1:max_iter
        f_min = compute_ET_diff(DB_min, ET, SV, PT);
        f_max = compute_ET_diff(DB_max, ET, SV, PT);
        if abs(f_min) < tol
            DB_solution = DB_min;
            fprintf('Solution found at the lower bound: DB = %f °C\n', DB_solution);
            return;
        elseif abs(f_max) < tol
            DB_solution = DB_max;
            fprintf('Solution found at the upper bound: DB = %f °C\n', DB_solution);
            return;
        end
        if f_min * f_max > 0
            error('No root found within the given interval.');
        end
        DB_mid = (DB_min + DB_max) / 2;
        f_mid = compute_ET_diff(DB_mid, ET, SV, PT);
        if abs(f_mid) < tol
            fprintf('Solution converged after %d iterations.\n', iter);
            DB_solution = DB_mid;
            break;
        end
        if f_min * f_mid < 0
            DB_max = DB_mid;
        else
            DB_min = DB_mid;
        end
    end
    if iter == max_iter
        fprintf('Max iterations reached. Solution may not have fully converged.\n');
    end
    fprintf('The value of DB is: %f °C\n', DB_solution);
    DB=DB_solution;
    SH=(ET-(1.005*DB))/(2500+(1.88*DB)) %in kg/kg
    PV=PT/((0.622/SH)+1) %in kpa
    PS=getSaturationPressure(DB);
    RH=(PV/PS)*100 %in percentage
    DP=getSaturationTemperature(PV)
    WB=-4.391976+(0.0198197*RH)+(0.526359*DB)+(0.00730271*RH*DB)+(2.4315*(10^(-4))*(RH^(2)))-(2.58101*(10^(-5))*DB*(RH^(2)))
    graph2D(PT,ET,PV,RH,SV,WB);
end

function et_pv
    H=input('Enter height from sea level(in m)');
    PT=101.325*((1-(2.25577*(10^(-5))*H))^5.2559); %in kpa
    ET=input('Enter Enthalpy\n');
    PV=input('Enter Vapour Pressure\n');
    SH=0.622*(PV/(PT-PV)) %in kg/kg
    DP=getSaturationTemperature(PV)
    DB=(ET-(2500*SH))/(1.005+(1.88*SH))
    PS=getSaturationPressure(DB);
    RH=(PV/PS)*100 %in percentage
    SV=0.2871*(DB+273.15)/(PT-PV) %in m3/kg
    WB=-4.391976+(0.0198197*RH)+(0.526359*DB)+(0.00730271*RH*DB)+(2.4315*(10^(-4))*(RH^(2)))-(2.58101*(10^(-5))*DB*(RH^(2)))
    graph2D(PT,ET,PV,RH,SV,WB);
end

function et_dp
    H=input('Enter height from sea level(in m)');
    PT=101.325*((1-(2.25577*(10^(-5))*H))^5.2559); %in kpa
    ET=input('Enter Enthalpy\n');
    DP=input('Enter Dew Point Temperature\n');
    PV=getSaturationPressure(DP)
    SH=0.622*(PV/(PT-PV)) %in kg/kg
    DB=(ET-(2500*SH))/(1.005+(1.88*SH))
    PS=getSaturationPressure(DB);
    RH=(PV/PS)*100 %in percentage
    SV=0.2871*(DB+273.15)/(PT-PV) %in m3/kg
    WB=-4.391976+(0.0198197*RH)+(0.526359*DB)+(0.00730271*RH*DB)+(2.4315*(10^(-4))*(RH^(2)))-(2.58101*(10^(-5))*DB*(RH^(2)))
    graph2D(PT,ET,PV,RH,SV,WB);
end

function wb_sv
    H=input('Enter height from sea level(in m)');
    PT=101.325*((1-(2.25577*(10^(-5))*H))^5.2559); %in kpa
    WB=input('Enter Wet Bulb Temperature\n');
    SV=input('Enter Specific Volume\n');
    PC = 22100;
    TC = 647.30;
    epsilon = 1e-6;
    DB = WB;
    error = 1;
    while error > epsilon
        K = 4.39553 - 6.2442*((DB + 273.15)/1000) + 9.953*((DB + 273.15)/1000)^2 - 5.151*((DB + 273.15)/1000)^3;
        PS = PC * (10^(K * (1 - (TC / (DB + 273.15)))));
        KWET = 4.39553 - 6.2442*((WB + 273.15)/1000) + 9.953*((WB + 273.15)/1000)^2 - 5.151*((WB + 273.15)/1000)^3;
        PSWET = PC * (10^(KWET * (1 - (TC / (WB + 273.15)))));
        PV = PSWET - ((PT * (DB - WB) / 1514) * (1 + (WB / 873)));
        SV_calc = 0.2871 * (DB + 273.15) / (PT - PV);
        RH = (PV / PS) * 100;
        error = abs(SV_calc - SV);
        if error > epsilon
            DB = DB - 0.1 * (SV_calc - SV);
        end
    end
    fprintf('The calculated Dry Bulb temperature (DB) is %.4f°C\n', DB);
    PS=getSaturationPressure(DB);
    PV=PT-(0.2871*(DB+273.15)/SV) %in kpa
    SH=0.622*(PV/(PT-PV)) %in kg/kg
    DP=getSaturationTemperature(PV)
    RH=(PV/PS)*100 %in percentage
    ET=(1.005*DB)+SH*(2500+(1.88*DB)) %in kj/kg
    graph2D(PT,ET,PV,RH,SV,WB);
end

function wb_pv
    H=input('Enter height from sea level(in m)');
    PT=101.325*((1-(2.25577*(10^(-5))*H))^5.2559); %in kpa
    WB=input('Enter Wet Bulb Temperature\n');
    PV=input('Enter Vapour Pressure\n');
    DP=getSaturationTemperature(PV)
    SH=0.622*(PV/(PT-PV)) %in kg/kg
    PSWET=getSaturationPressure(WB);
    DB=WB+((PSWET-PV)/(PT*0.00066)) %in degree celcius close value
    PS=getSaturationPressure(DB);
    RH=(PV/PS)*100 %in percentage
    ET=(1.005*DB)+SH*(2500+(1.88*DB)) %in kj/kg
    SV=0.2871*(DB+273.15)/(PT-PV) %in m3/kg
    graph2D(PT,ET,PV,RH,SV,WB);
end

function wb_dp
    H=input('Enter height from sea level(in m)');
    PT=101.325*((1-(2.25577*(10^(-5))*H))^5.2559); %in kpa
    WB=input('Enter Wet Bulb Temperature\n');
    DP=input('Enter Dew Point Temperature\n');
    PV=getSaturationPressure(DP)
    SH=0.622*(PV/(PT-PV)) %in kg/kg
    PSWET=getSaturationPressure(WB);
    DB=WB+((PSWET-PV)/(PT*0.00066)) %in degree celcius close value
    PS=getSaturationPressure(DB);
    RH=(PV/PS)*100 %in percentage
    ET=(1.005*DB)+SH*(2500+(1.88*DB)) %in kj/kg
    SV=0.2871*(DB+273.15)/(PT-PV) %in m3/kg
    graph2D(PT,ET,PV,RH,SV,WB);
end

function sv_pv
    H=input('Enter height from sea level(in m)');
    PT=101.325*((1-(2.25577*(10^(-5))*H))^5.2559); %in kpa
    SV=input('Enter Specific Volume\n');
    PV=input('Enter Vapour Pressure\n');
    DB=(SV*(PT-PV)/0.2871)-273.15
    PS=getSaturationPressure(DB);
    RH=(PV/PS)*100 %in percentage
    SH=0.622*(PV/(PT-PV)) %in kg/kg
    DP=getSaturationTemperature(PV)
    ET=(1.005*DB)+SH*(2500+(1.88*DB)) %in kj/kg
    WB=-4.391976+(0.0198197*RH)+(0.526359*DB)+(0.00730271*RH*DB)+(2.4315*(10^(-4))*(RH^(2)))-(2.58101*(10^(-5))*DB*(RH^(2)))
    graph2D(PT,ET,PV,RH,SV,WB);
end

function sv_dp
    H=input('Enter height from sea level(in m)');
    PT=101.325*((1-(2.25577*(10^(-5))*H))^5.2559); %in kpa
    SV=input('Enter Specific Volume\n');
    DP=input('Enter Dew Point Temperature\n');
    PV=getSaturationPressure(DP)
    SH=0.622*(PV/(PT-PV)) %in kg/kg
    DB=(SV*(PT-PV)/0.2871)-273.15
    PS=getSaturationPressure(DB);
    RH=(PV/PS)*100 %in percentage
    ET=(1.005*DB)+SH*(2500+(1.88*DB)) %in kj/kg
    WB=-4.391976+(0.0198197*RH)+(0.526359*DB)+(0.00730271*RH*DB)+(2.4315*(10^(-4))*(RH^(2)))-(2.58101*(10^(-5))*DB*(RH^(2)))
    graph2D(PT,ET,PV,RH,SV,WB);
end

function graph2D(PT,ET,PV,RH,SV,WB)
    x1=linspace(-40,65,1000);
    y1=(ET-(1.005*x1))./(2500+(1.88*x1));
    y_constant=0.622*(PV/(PT-PV));
    y2=y_constant*ones(size(x1));
    PS=getSaturationPressure(x1);
    PV3=(RH*PS)/100;
    y3=0.622*(PV3./(PT-PV3));
    PV4=PT-(0.2871*(x1+273.15)/SV);
    y4=0.622*(PV4./(PT-PV4));
    PSWET=getSaturationPressure(WB);
    P=PT*((x1-WB)/1514)*(1+(WB/873));
    RH5=((PSWET-P)./PS)*100;
    PV5=(RH5.*PS)/100;
    y5=0.622*(PV5./(PT-PV5));
    plot(x1,y1,x1,y2,x1,y3,x1,y4,x1,y5);
    axis([-40 65 0 0.0550]);
    xlabel('DB')
    ylabel('SH')
    title('ET,PV,RH,SV,WB')
end

function graph3D()
    x1=linspace(-40,65,1000);
    y1=linspace(79.495,101.325,1000);
    [x1,y1]=meshgrid(x1,y1);
    choice=input('Which value is given\n1. ET\n2. PV\n3. RH\n4. SV\n5. WB\n');
    if(choice==1)
        ET=input('Enter Enthalpy:');
        z1=(ET-(1.005*x1))./(2500+(1.88*x1));
        figure;
        surf(x1,y1,z1);
        title('ET')
    end
    if(choice==2)
        PV=input('Enter Vapour Pressure:');
        z2=0.622*(PV./(y1-PV));
        figure;
        surf(x1,y1,z2);
        title('PV')
    end
    if(choice==3)
        RH=input('Enter Relative Humidity:');
        PS=getSaturationPressure(x1);
        PV3=(RH*PS)/100;
        z3=0.622*(PV3./(y1-PV3));
        figure;
        surf(x1,y1,z3);
        title('RH')
    end
    if(choice==4)
        SV=input('Enter Specific Volume:');
        PV4=y1-(0.2871*(x1+273.15)/SV);
        z4=0.622*(PV4./(y1-PV4));
        figure;
        surf(x1,y1,z4);
        title('SV')
    end
    if(choice==5)
        WB=input('Enter Wet Bulb Temperature:');
        PSWET=getSaturationPressure(WB);
        P=y1.*((x1-WB)/1514)*(1+(WB/873));
        RH5=((PSWET-P)./PS)*100;
        PV5=(RH5.*PS)/100;
        z5=0.622*(PV5./(y1-PV5));
        figure;
        surf(x1,y1,z5);
        title('WB')
    end
    xlabel('DB')
    ylabel('PT')
    zlabel('SH')
    colorbar;
end

function graph_full()
    H=input('Enter height from sea level(in m)');
    PT=101.325*((1-(2.25577*(10^(-5))*H))^5.2559); %in kpa
    ET_values=-20:10:180;
    PV_values=0:0.5:8.2317;
    RH_values=0:10:100;
    SV_values=0.760:0.02:1.020;
    WB_values=-10:5:40;
    x1=linspace(-40,65,1000);
    ET_color='r';
    PV_color='g';
    RH_color='b';
    SV_color='m';
    WB_color='c';
    figure;
    hold on;
    for ET=ET_values
        y1=(ET-(1.005*x1))./(2500+(1.88*x1));
        plot(x1,y1,'color',ET_color);
    end
    for PV=PV_values
        y_constant=0.622*(PV/(PT-PV));
        y2=y_constant*ones(size(x1));
        plot(x1,y2,'color',PV_color);
    end
    for RH=RH_values
        PS=getSaturationPressure(x1);
        PV3=(RH*PS)/100;
        y3=0.622*(PV3./(PT-PV3));
        plot(x1,y3,'color',RH_color);
    end
    for SV=SV_values
        PV4=PT-(0.2871*(x1+273.15)/SV);
        y4=0.622*(PV4./(PT-PV4));
        plot(x1,y4,'color',SV_color);
    end
    for WB=WB_values
        PSWET=getSaturationPressure(WB);
        P=PT*((x1-WB)/1514)*(1+(WB/873));
        RH5=((PSWET-P)./PS)*100;
        PV5=(RH5.*PS)/100;
        y5=0.622*(PV5./(PT-PV5));
        plot(x1,y5,'color',WB_color);
    end
    axis([-40 65 0 0.0550]);
    xlabel('DB')
    ylabel('SH')
    title('ET,PV,RH,SV,WB')
    %legend show;
    grid on;
    hold off;
end

function P_sat = getSaturationPressure(T)
    T_data = [-60, -59, -58, -57, -56, -55, -54, -53, -52, -51, -50, -49, -48, -47, -46, -45, -44, -43, -42, -41, -40 , -39, -38, -37, -36, -35, -34, -33, -32, -31, -30, -29, -28, -27, -26, -25, -24, -23, -22, -21, -20, -19, -18, -17, -16, -15, -14, -13, -12, -11, -10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 122, 124, 126, 128, 130, 132, 134, 136, 138, 140, 142, 144, 146, 148, 150, 152, 154, 156, 158, 160];
    P_data = [0.00108, 0.00124, 0.00141, 0.00161, 0.00184, 0.00209, 0.00238, 0.00271, 0.00307, 0.00348, 0.00394, 0.00445, 0.00503, 0.00568, 0.00640, 0.00720, 0.00810, 0.00910, 0.01022, 0.01146, 0.01284, 0.01437, 0.01607, 0.01795, 0.02004, 0.02234, 0.02489, 0.02771, 0.03081, 0.03423, 0.03801, 0.04215, 0.04672, 0.05173, 0.05724, 0.06237, 0.06989, 0.07714, 0.08508, 0.09376, 0.10324, 0.11360, 0.12490, 0.13722, 0.15065, 0.16527, 0.18119, 0.19849, 0.21729, 0.23771, 0.25987, 0.28391, 0.30995, 0.33817, 0.36871, 0.40174, 0.43745, 0.47604, 0.51770, 0.56266, 0.61115, 0.6571, 0.7060, 0.7581, 0.8135, 0.8726, 0.9354, 1.0021, 1.0730, 1.1483, 1.2282, 1.3129, 1.4028, 1.4981, 1.5989, 1.7057, 1.8188, 1.9383, 2.0647, 2.1982, 2.3392, 2.4881, 2.6452, 2.8109, 2.9856, 3.1697, 3.3637, 3.5679, 3.7828, 4.0089, 4.2467, 4.4966, 4.7592, 5.0351, 5.3247, 5.6286, 5.9475, 6.2818, 6.6324, 6.9997, 7.3844, 7.7873, 8.2090, 8.6503, 9.1118, 9.5944, 10.0988, 10.6259, 11.1764, 11.7512, 12.3513, 12.9774, 13.6305, 14.3116, 15.0215, 15.7614, 16.5322, 17.3350, 18.1708, 19.0407, 19.9458, 20.8873, 21.8664, 22.8842, 23.9421, 25.0411, 26.1827, 27.3680, 28.5986, 29.8756, 31.2006, 32.5750, 34.0001, 35.4775, 37.0088, 38.5954, 40.2389, 41.9409, 43.7031, 45.5271, 47.4147, 49.3676, 51.3875, 53.4762, 55.6355, 57.8675, 60.1738, 62.5565, 65.0174, 67.5587, 70.1824, 72.8904, 75.6849, 78.5681, 81.5420, 84.6089, 87.7711, 91.0308, 94.3902, 97.8518, 101.4180, 105.0910, 108.8735, 112.7678, 116.7765, 120.9021, 125.1472, 129.5145, 134.0065, 138.6261, 143.3760, 148.2588, 153.2775, 158.4348, 163.7737, 169.1770, 174.7678, 180.5090, 186.4036, 192.4547, 198.6654, 211.5782, 225.1676, 239.4597, 254.4813, 270.2596, 286.8226, 304.1989, 322.4175, 341.5081, 361.5010, 382.4271, 404.3178, 427.2053, 451.1220, 476.1014, 502.1771, 529.3834, 557.7555, 587.3287, 618.1392];
    P_sat = interp1(T_data, P_data, T, 'pchip', 'extrap');
end

function T_sat = getSaturationTemperature(P)
    T_data = [-60, -59, -58, -57, -56, -55, -54, -53, -52, -51, -50, -49, -48, -47, -46, -45, -44, -43, -42, -41, -40 , -39, -38, -37, -36, -35, -34, -33, -32, -31, -30, -29, -28, -27, -26, -25, -24, -23, -22, -21, -20, -19, -18, -17, -16, -15, -14, -13, -12, -11, -10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 122, 124, 126, 128, 130, 132, 134, 136, 138, 140, 142, 144, 146, 148, 150, 152, 154, 156, 158, 160];
    P_data = [0.00108, 0.00124, 0.00141, 0.00161, 0.00184, 0.00209, 0.00238, 0.00271, 0.00307, 0.00348, 0.00394, 0.00445, 0.00503, 0.00568, 0.00640, 0.00720, 0.00810, 0.00910, 0.01022, 0.01146, 0.01284, 0.01437, 0.01607, 0.01795, 0.02004, 0.02234, 0.02489, 0.02771, 0.03081, 0.03423, 0.03801, 0.04215, 0.04672, 0.05173, 0.05724, 0.06237, 0.06989, 0.07714, 0.08508, 0.09376, 0.10324, 0.11360, 0.12490, 0.13722, 0.15065, 0.16527, 0.18119, 0.19849, 0.21729, 0.23771, 0.25987, 0.28391, 0.30995, 0.33817, 0.36871, 0.40174, 0.43745, 0.47604, 0.51770, 0.56266, 0.61115, 0.6571, 0.7060, 0.7581, 0.8135, 0.8726, 0.9354, 1.0021, 1.0730, 1.1483, 1.2282, 1.3129, 1.4028, 1.4981, 1.5989, 1.7057, 1.8188, 1.9383, 2.0647, 2.1982, 2.3392, 2.4881, 2.6452, 2.8109, 2.9856, 3.1697, 3.3637, 3.5679, 3.7828, 4.0089, 4.2467, 4.4966, 4.7592, 5.0351, 5.3247, 5.6286, 5.9475, 6.2818, 6.6324, 6.9997, 7.3844, 7.7873, 8.2090, 8.6503, 9.1118, 9.5944, 10.0988, 10.6259, 11.1764, 11.7512, 12.3513, 12.9774, 13.6305, 14.3116, 15.0215, 15.7614, 16.5322, 17.3350, 18.1708, 19.0407, 19.9458, 20.8873, 21.8664, 22.8842, 23.9421, 25.0411, 26.1827, 27.3680, 28.5986, 29.8756, 31.2006, 32.5750, 34.0001, 35.4775, 37.0088, 38.5954, 40.2389, 41.9409, 43.7031, 45.5271, 47.4147, 49.3676, 51.3875, 53.4762, 55.6355, 57.8675, 60.1738, 62.5565, 65.0174, 67.5587, 70.1824, 72.8904, 75.6849, 78.5681, 81.5420, 84.6089, 87.7711, 91.0308, 94.3902, 97.8518, 101.4180, 105.0910, 108.8735, 112.7678, 116.7765, 120.9021, 125.1472, 129.5145, 134.0065, 138.6261, 143.3760, 148.2588, 153.2775, 158.4348, 163.7737, 169.1770, 174.7678, 180.5090, 186.4036, 192.4547, 198.6654, 211.5782, 225.1676, 239.4597, 254.4813, 270.2596, 286.8226, 304.1989, 322.4175, 341.5081, 361.5010, 382.4271, 404.3178, 427.2053, 451.1220, 476.1014, 502.1771, 529.3834, 557.7555, 587.3287, 618.1392];
    T_sat = interp1(P_data, T_data, P, 'pchip', 'extrap');
end