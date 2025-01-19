function psychrometry()
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
    ALPHA=log(PV);
    DP=6.54+14.526*ALPHA+0.7389*(ALPHA^2)+0.0949*(ALPHA^3)+0.4569*(PV^0.1984) %in degree celcius
    PC=22100;
    TC=647.30;
    K=4.39553-6.2442*((DB+273.15)/1000)+9.953*(((DB+273.15)/1000)^2)-5.151*(((DB+273.15)/1000)^3);
    PS=PC*(10^(K*(1-(TC/(DB+273.15)))));
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
    PC=22100;
    TC=647.30;
    K=4.39553-6.2442*((DB+273.15)/1000)+9.953*(((DB+273.15)/1000)^2)-5.151*(((DB+273.15)/1000)^3);
    PS=PC*(10^(K*(1-(TC/(DB+273.15)))));
    PV=(RH*PS)/100 %in kpa
    SV=0.2871*(DB+273.15)/(PT-PV) %in m3/kg
    SH=0.622*(PV/(PT-PV)) %in kg/kg
    ET=(1.005*DB)+SH*(2500+(1.88*DB)) %in kj/kg
    ALPHA=log(PV);
    DP=6.54+14.526*ALPHA+0.7389*(ALPHA^2)+0.0949*(ALPHA^3)+0.4569*(PV^0.1984) %in degree celcius
    WB=-4.391976+(0.0198197*RH)+(0.526359*DB)+(0.00730271*RH*DB)+(2.4315*(10^(-4))*(RH^(2)))-(2.58101*(10^(-5))*DB*(RH^(2)))
    graph2D(PT,ET,PV,RH,SV,WB);
end

function db_et
    H=input('Enter height from sea level(in m)');
    PT=101.325*((1-(2.25577*(10^(-5))*H))^5.2559); %in kpa
    DB=input('Enter Dry Bulb Temperature(in degree celcius)\n');
    ET=input('Enter Enthalpy(in kj/kg)\n');
    PC=22100;
    TC=647.30;
    K=4.39553-6.2442*((DB+273.15)/1000)+9.953*(((DB+273.15)/1000)^2)-5.151*(((DB+273.15)/1000)^3);
    PS=PC*(10^(K*(1-(TC/(DB+273.15)))));
    SH=(ET-(1.005*DB))/(2500+(1.88*DB)) %in kg/kg
    PV=PT/((0.622/SH)+1) %in kpa
    ALPHA=log(PV);
    DP=6.54+14.526*ALPHA+0.7389*(ALPHA^2)+0.0949*(ALPHA^3)+0.4569*(PV^0.1984) %in degree celcius
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
    PC=22100;
    TC=647.30;
    K=4.39553-6.2442*((DB+273.15)/1000)+9.953*(((DB+273.15)/1000)^2)-5.151*(((DB+273.15)/1000)^3);
    PS=PC*(10^(K*(1-(TC/(DB+273.15)))));
    KWET=4.39553-6.2442*((WB+273.15)/1000)+9.953*(((WB+273.15)/1000)^2)-5.151*(((WB+273.15)/1000)^3);
    PSWET=PC*(10^(KWET*(1-(TC/(WB+273.15)))));
    P=PT*((DB-WB)/1514)*(1+(WB/873));
    RH=((PSWET-P)/PS)*100 %in percentage
    PV=(RH*PS)/100 %in kpa
    SV=0.2871*(DB+273.15)/(PT-PV) %in m3/kg
    SH=0.622*(PV/(PT-PV)) %in kg/kg
    ET=(1.005*DB)+SH*(2500+(1.88*DB)) %in kj/kg
    ALPHA=log(PV);
    DP=6.54+14.526*ALPHA+0.7389*(ALPHA^2)+0.0949*(ALPHA^3)+0.4569*(PV^0.1984) %in degree celcius
    graph2D(PT,ET,PV,RH,SV,WB);
end

function db_sv
    H=input('Enter height from sea level(in m)');
    PT=101.325*((1-(2.25577*(10^(-5))*H))^5.2559); %in kpa
    DB=input('Enter Dry Bulb Temperature\n');
    SV=input('Enter Specific Volume\n');
    PC=22100;
    TC=647.30;
    K=4.39553-6.2442*((DB+273.15)/1000)+9.953*(((DB+273.15)/1000)^2)-5.151*(((DB+273.15)/1000)^3);
    PS=PC*(10^(K*(1-(TC/(DB+273.15)))));
    PV=PT-(0.2871*(DB+273.15)/SV) %in kpa
    SH=0.622*(PV/(PT-PV)) %in kg/kg
    ET=(1.005*DB)+SH*(2500+(1.88*DB)) %in kj/kg
    ALPHA=log(PV);
    DP=6.54+14.526*ALPHA+0.7389*(ALPHA^2)+0.0949*(ALPHA^3)+0.4569*(PV^0.1984) %in degree celcius
    RH=(PV/PS)*100 %in percentage
    WB=-4.391976+(0.0198197*RH)+(0.526359*DB)+(0.00730271*RH*DB)+(2.4315*(10^(-4))*(RH^(2)))-(2.58101*(10^(-5))*DB*(RH^(2)))
    graph2D(PT,ET,PV,RH,SV,WB);
end

function db_pv
    H=input('Enter height from sea level(in m)');
    PT=101.325*((1-(2.25577*(10^(-5))*H))^5.2559); %in kpa
    DB=input('Enter Dry Bulb Temperature\n');
    PV=input('Enter Vapour Pressure\n');
    PC=22100;
    TC=647.30;
    K=4.39553-6.2442*((DB+273.15)/1000)+9.953*(((DB+273.15)/1000)^2)-5.151*(((DB+273.15)/1000)^3);
    PS=PC*(10^(K*(1-(TC/(DB+273.15)))));
    RH=(PV/PS)*100 %in percentage
    SH=0.622*(PV/(PT-PV)) %in kg/kg
    ET=(1.005*DB)+SH*(2500+(1.88*DB)) %in kj/kg
    ALPHA=log(PV);
    DP=6.54+14.526*ALPHA+0.7389*(ALPHA^2)+0.0949*(ALPHA^3)+0.4569*(PV^0.1984) %in degree celcius
    SV=0.2871*(DB+273.15)/(PT-PV) %in m3/kg
    WB=-4.391976+(0.0198197*RH)+(0.526359*DB)+(0.00730271*RH*DB)+(2.4315*(10^(-4))*(RH^(2)))-(2.58101*(10^(-5))*DB*(RH^(2)))
    graph2D(PT,ET,PV,RH,SV,WB);
end

function db_dp
    H=input('Enter height from sea level(in m)');
    PT=101.325*((1-(2.25577*(10^(-5))*H))^5.2559); %in kpa
    DB=input('Enter Dry Bulb Temperature\n');
    DP=input('Enter Dew Point Temperature\n');
    PC=22100;
    TC=647.30;
    K=4.39553-6.2442*((DB+273.15)/1000)+9.953*(((DB+273.15)/1000)^2)-5.151*(((DB+273.15)/1000)^3);
    PS=PC*(10^(K*(1-(TC/(DB+273.15)))));
    KDP=4.39553-6.2442*((DP+273.15)/1000)+9.953*(((DP+273.15)/1000)^2)-5.151*(((DP+273.15)/1000)^3);
    PV=PC*(10^(KDP*(1-(TC/(DP+273.15))))) %in kpa
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
    ALPHA=log(PS);
    DB=6.54+14.526*ALPHA+0.7389*(ALPHA^2)+0.0949*(ALPHA^3)+0.4569*(PS^0.1984) %in degree celcius
    ET=(1.005*DB)+SH*(2500+(1.88*DB)) %in kj/kg
    ALPHA=log(PV);
    DP=6.54+14.526*ALPHA+0.7389*(ALPHA^2)+0.0949*(ALPHA^3)+0.4569*(PV^0.1984) %in degree celcius
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
    ALPHA=log(PV);
    DP=6.54+14.526*ALPHA+0.7389*(ALPHA^2)+0.0949*(ALPHA^3)+0.4569*(PV^0.1984) %in degree celcius
    DB=(ET-(2500*SH))/(1.005+(1.88*SH))
    PC=22100;
    TC=647.30;
    K=4.39553-6.2442*((DB+273.15)/1000)+9.953*(((DB+273.15)/1000)^2)-5.151*(((DB+273.15)/1000)^3);
    PS=PC*(10^(K*(1-(TC/(DB+273.15)))));
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
    ALPHA=log(PV);
    DP=6.54+14.526*ALPHA+0.7389*(ALPHA^2)+0.0949*(ALPHA^3)+0.4569*(PV^0.1984) %in degree celcius
    PC=22100;
    TC=647.30;
    KWET=4.39553-6.2442*((WB+273.15)/1000)+9.953*(((WB+273.15)/1000)^2)-5.151*(((WB+273.15)/1000)^3);
    PSWET=PC*(10^(KWET*(1-(TC/(WB+273.15)))));
    DB=WB+((PSWET-PV)/(PT*0.00066)) %in degree celcius close value
    K=4.39553-6.2442*((DB+273.15)/1000)+9.953*(((DB+273.15)/1000)^2)-5.151*(((DB+273.15)/1000)^3);
    PS=PC*(10^(K*(1-(TC/(DB+273.15)))));
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
    ALPHA=log(PV);
    DP=6.54+14.526*ALPHA+0.7389*(ALPHA^2)+0.0949*(ALPHA^3)+0.4569*(PV^0.1984) %in degree celcius
    DB=(SV*(PT-PV)/0.2871)-273.15
    PC=22100;
    TC=647.30;
    K=4.39553-6.2442*((DB+273.15)/1000)+9.953*(((DB+273.15)/1000)^2)-5.151*(((DB+273.15)/1000)^3);
    PS=PC*(10^(K*(1-(TC/(DB+273.15)))));
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
    ALPHA=log(PV);
    DP=6.54+14.526*ALPHA+0.7389*(ALPHA^2)+0.0949*(ALPHA^3)+0.4569*(PV^0.1984) %in degree celcius
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
    compute_RH_diff = @(DB)RH - (((PC * 10^((4.39553 - 6.2442*((WB+273.15)/1000) + 9.953*(((WB+273.15)/1000)^2) - 5.151*(((WB+273.15)/1000)^3)) * (1 - (TC/(WB+273.15))))) - (PT * ((DB-WB)/1514)*(1 + (WB/873)))) / (PC * 10^((4.39553 - 6.2442*((DB+273.15)/1000) + 9.953*(((DB+273.15)/1000)^2) - 5.151*(((DB+273.15)/1000)^3)) * (1 - (TC/(DB+273.15))))) * 100);
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
    K=4.39553-6.2442*((DB+273.15)/1000)+9.953*(((DB+273.15)/1000)^2)-5.151*(((DB+273.15)/1000)^3);
    PS=PC*(10^(K*(1-(TC/(DB+273.15)))));
    PV=(RH*PS)/100 %in kpa
    SH=0.622*(PV/(PT-PV)) %in kg/kg
    ET=(1.005*DB)+SH*(2500+(1.88*DB)) %in kj/kg
    SV=0.2871*(DB+273.15)/(PT-PV) %in m3/kg
    ALPHA=log(PV);
    DP=6.54+14.526*ALPHA+0.7389*(ALPHA^2)+0.0949*(ALPHA^3)+0.4569*(PV^0.1984) %in degree celcius
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
    ALPHA=log(PS);
    DB=6.54+14.526*ALPHA+0.7389*(ALPHA^2)+0.0949*(ALPHA^3)+0.4569*(PS^0.1984) %in degree celcius
    PV=(RH*PS)/100 %in kpa
    ALPHA=log(PV);
    DP=6.54+14.526*ALPHA+0.7389*(ALPHA^2)+0.0949*(ALPHA^3)+0.4569*(PV^0.1984) %in degree celcius
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
    ALPHA=log(PS);
    DB=6.54+14.526*ALPHA+0.7389*(ALPHA^2)+0.0949*(ALPHA^3)+0.4569*(PS^0.1984) %in degree celcius
    SH=0.622*(PV/(PT-PV)) %in kg/kg
    WB=-4.391976+(0.0198197*RH)+(0.526359*DB)+(0.00730271*RH*DB)+(2.4315*(10^(-4))*(RH^(2)))-(2.58101*(10^(-5))*DB*(RH^(2)))
    ALPHA=log(PV);
    DP=6.54+14.526*ALPHA+0.7389*(ALPHA^2)+0.0949*(ALPHA^3)+0.4569*(PV^0.1984) %in degree celcius
    ET=(1.005*DB)+SH*(2500+(1.88*DB)) %in kj/kg
    SV=0.2871*(DB+273.15)/(PT-PV) %in m3/kg
    graph2D(PT,ET,PV,RH,SV,WB);
end

function rh_dp
    H=input('Enter height from sea level(in m)');
    PT=101.325*((1-(2.25577*(10^(-5))*H))^5.2559); %in kpa
    RH=input('Enter Relative Humidity\n');
    DP=input('Enter Dew Point Temperature\n');
    PC=22100;
    TC=647.30;
    KDP=4.39553-6.2442*((DP+273.15)/1000)+9.953*(((DP+273.15)/1000)^2)-5.151*(((DP+273.15)/1000)^3);
    PV=PC*(10^(KDP*(1-(TC/(DP+273.15))))) %in kpa
    PS=(PV/RH)*100;
    ALPHA=log(PS);
    DB=6.54+14.526*ALPHA+0.7389*(ALPHA^2)+0.0949*(ALPHA^3)+0.4569*(PS^0.1984) %in degree celcius
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
    PC=22100;
    TC=647.30;
    K=4.39553-6.2442*((DB+273.15)/1000)+9.953*(((DB+273.15)/1000)^2)-5.151*(((DB+273.15)/1000)^3);
    PS=PC*(10^(K*(1-(TC/(DB+273.15)))));
    RH=(PV/PS)*100 %in percentage
    ALPHA=log(PV);
    DP=6.54+14.526*ALPHA+0.7389*(ALPHA^2)+0.0949*(ALPHA^3)+0.4569*(PV^0.1984) %in degree celcius
    WB=-4.391976+(0.0198197*RH)+(0.526359*DB)+(0.00730271*RH*DB)+(2.4315*(10^(-4))*(RH^(2)))-(2.58101*(10^(-5))*DB*(RH^(2)))
    graph2D(PT,ET,PV,RH,SV,WB);
end

function et_pv
    H=input('Enter height from sea level(in m)');
    PT=101.325*((1-(2.25577*(10^(-5))*H))^5.2559); %in kpa
    ET=input('Enter Enthalpy\n');
    PV=input('Enter Vapour Pressure\n');
    SH=0.622*(PV/(PT-PV)) %in kg/kg
    ALPHA=log(PV);
    DP=6.54+14.526*ALPHA+0.7389*(ALPHA^2)+0.0949*(ALPHA^3)+0.4569*(PV^0.1984) %in degree celcius
    DB=(ET-(2500*SH))/(1.005+(1.88*SH))
    PC=22100;
    TC=647.30;
    K=4.39553-6.2442*((DB+273.15)/1000)+9.953*(((DB+273.15)/1000)^2)-5.151*(((DB+273.15)/1000)^3);
    PS=PC*(10^(K*(1-(TC/(DB+273.15)))));
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
    PC=22100;
    TC=647.30;
    KDP=4.39553-6.2442*((DP+273.15)/1000)+9.953*(((DP+273.15)/1000)^2)-5.151*(((DP+273.15)/1000)^3);
    PV=PC*(10^(KDP*(1-(TC/(DP+273.15))))) %in kpa
    SH=0.622*(PV/(PT-PV)) %in kg/kg
    DB=(ET-(2500*SH))/(1.005+(1.88*SH))
    PC=22100;
    TC=647.30;
    K=4.39553-6.2442*((DB+273.15)/1000)+9.953*(((DB+273.15)/1000)^2)-5.151*(((DB+273.15)/1000)^3);
    PS=PC*(10^(K*(1-(TC/(DB+273.15)))));
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
    K=4.39553-6.2442*((DB+273.15)/1000)+9.953*(((DB+273.15)/1000)^2)-5.151*(((DB+273.15)/1000)^3);
    PS=PC*(10^(K*(1-(TC/(DB+273.15)))));
    PV=PT-(0.2871*(DB+273.15)/SV) %in kpa
    SH=0.622*(PV/(PT-PV)) %in kg/kg
    ALPHA=log(PV);
    DP=6.54+14.526*ALPHA+0.7389*(ALPHA^2)+0.0949*(ALPHA^3)+0.4569*(PV^0.1984) %in degree celcius
    RH=(PV/PS)*100 %in percentage
    ET=(1.005*DB)+SH*(2500+(1.88*DB)) %in kj/kg
    graph2D(PT,ET,PV,RH,SV,WB);
end

function wb_pv
    H=input('Enter height from sea level(in m)');
    PT=101.325*((1-(2.25577*(10^(-5))*H))^5.2559); %in kpa
    WB=input('Enter Wet Bulb Temperature\n');
    PV=input('Enter Vapour Pressure\n');
    ALPHA=log(PV);
    DP=6.54+14.526*ALPHA+0.7389*(ALPHA^2)+0.0949*(ALPHA^3)+0.4569*(PV^0.1984) %in degree celcius
    SH=0.622*(PV/(PT-PV)) %in kg/kg
    PC=22100;
    TC=647.30;
    KWET=4.39553-6.2442*((WB+273.15)/1000)+9.953*(((WB+273.15)/1000)^2)-5.151*(((WB+273.15)/1000)^3);
    PSWET=PC*(10^(KWET*(1-(TC/(WB+273.15)))));
    DB=WB+((PSWET-PV)/(PT*0.00066)) %in degree celcius close value
    K=4.39553-6.2442*((DB+273.15)/1000)+9.953*(((DB+273.15)/1000)^2)-5.151*(((DB+273.15)/1000)^3);
    PS=PC*(10^(K*(1-(TC/(DB+273.15)))));
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
    PC=22100;
    TC=647.30;
    KDP=4.39553-6.2442*((DP+273.15)/1000)+9.953*(((DP+273.15)/1000)^2)-5.151*(((DP+273.15)/1000)^3);
    PV=PC*(10^(KDP*(1-(TC/(DP+273.15))))) %in kpa
    SH=0.622*(PV/(PT-PV)) %in kg/kg
    PC=22100;
    TC=647.30;
    KWET=4.39553-6.2442*((WB+273.15)/1000)+9.953*(((WB+273.15)/1000)^2)-5.151*(((WB+273.15)/1000)^3);
    PSWET=PC*(10^(KWET*(1-(TC/(WB+273.15)))));
    DB=WB+((PSWET-PV)/(PT*0.00066)) %in degree celcius close value
    K=4.39553-6.2442*((DB+273.15)/1000)+9.953*(((DB+273.15)/1000)^2)-5.151*(((DB+273.15)/1000)^3);
    PS=PC*(10^(K*(1-(TC/(DB+273.15)))));
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
    PC=22100;
    TC=647.30;
    K=4.39553-6.2442*((DB+273.15)/1000)+9.953*(((DB+273.15)/1000)^2)-5.151*(((DB+273.15)/1000)^3);
    PS=PC*(10^(K*(1-(TC/(DB+273.15)))));
    RH=(PV/PS)*100 %in percentage
    SH=0.622*(PV/(PT-PV)) %in kg/kg
    ALPHA=log(PV);
    DP=6.54+14.526*ALPHA+0.7389*(ALPHA^2)+0.0949*(ALPHA^3)+0.4569*(PV^0.1984) %in degree celcius
    ET=(1.005*DB)+SH*(2500+(1.88*DB)) %in kj/kg
    WB=-4.391976+(0.0198197*RH)+(0.526359*DB)+(0.00730271*RH*DB)+(2.4315*(10^(-4))*(RH^(2)))-(2.58101*(10^(-5))*DB*(RH^(2)))
    graph2D(PT,ET,PV,RH,SV,WB);
end

function sv_dp
    H=input('Enter height from sea level(in m)');
    PT=101.325*((1-(2.25577*(10^(-5))*H))^5.2559); %in kpa
    SV=input('Enter Specific Volume\n');
    DP=input('Enter Dew Point Temperature\n');
    PC=22100;
    TC=647.30;
    KDP=4.39553-6.2442*((DP+273.15)/1000)+9.953*(((DP+273.15)/1000)^2)-5.151*(((DP+273.15)/1000)^3);
    PV=PC*(10^(KDP*(1-(TC/(DP+273.15))))) %in kpa
    SH=0.622*(PV/(PT-PV)) %in kg/kg
    DB=(SV*(PT-PV)/0.2871)-273.15
    K=4.39553-6.2442*((DB+273.15)/1000)+9.953*(((DB+273.15)/1000)^2)-5.151*(((DB+273.15)/1000)^3);
    PS=PC*(10^(K*(1-(TC/(DB+273.15)))));
    RH=(PV/PS)*100 %in percentage
    ET=(1.005*DB)+SH*(2500+(1.88*DB)) %in kj/kg
    WB=-4.391976+(0.0198197*RH)+(0.526359*DB)+(0.00730271*RH*DB)+(2.4315*(10^(-4))*(RH^(2)))-(2.58101*(10^(-5))*DB*(RH^(2)))
    graph2D(PT,ET,PV,RH,SV,WB);
end

function graph2D(PT,ET,PV,RH,SV,WB)
    PC=22100;
    TC=647.30;
    x1=linspace(-40,65,1000);
    y1=(ET-(1.005*x1))./(2500+(1.88*x1));
    y_constant=0.622*(PV/(PT-PV));
    y2=y_constant*ones(size(x1));
    K=4.39553-6.2442*((x1+273.15)/1000)+9.953*(((x1+273.15)/1000).^2)-5.151*(((x1+273.15)/1000).^3);
    PS=PC*(10.^(K.*(1-(TC./(x1+273.15)))));
    PV3=(RH*PS)/100;
    y3=0.622*(PV3./(PT-PV3));
    PV4=PT-(0.2871*(x1+273.15)/SV);
    y4=0.622*(PV4./(PT-PV4));
    KWET=4.39553-6.2442*((WB+273.15)/1000)+9.953*(((WB+273.15)/1000)^2)-5.151*(((WB+273.15)/1000)^3);
    PSWET=PC*(10^(KWET*(1-(TC/(WB+273.15)))));
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
    PC=22100;
    TC=647.30;
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
        K=4.39553-6.2442*((x1+273.15)/1000)+9.953*(((x1+273.15)/1000).^2)-5.151*(((x1+273.15)/1000).^3);
        PS=PC*(10.^(K.*(1-(TC./(x1+273.15)))));
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
        KWET=4.39553-6.2442*((WB+273.15)/1000)+9.953*(((WB+273.15)/1000)^2)-5.151*(((WB+273.15)/1000)^3);
        PSWET=PC*(10^(KWET*(1-(TC/(WB+273.15)))));
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
    PC=22100;
    TC=647.30;
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
        K=4.39553-6.2442*((x1+273.15)/1000)+9.953*(((x1+273.15)/1000).^2)-5.151*(((x1+273.15)/1000).^3);
        PS=PC*(10.^(K.*(1-(TC./(x1+273.15)))));
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
        KWET=4.39553-6.2442*((WB+273.15)/1000)+9.953*(((WB+273.15)/1000)^2)-5.151*(((WB+273.15)/1000)^3);
        PSWET=PC*(10^(KWET*(1-(TC/(WB+273.15)))));
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