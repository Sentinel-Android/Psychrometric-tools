import numpy as np
import matplotlib.pyplot as plt
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg
from mpl_toolkits.mplot3d import Axes3D
from scipy.interpolate import PchipInterpolator
import math

def psychrometric_calculator(prop1, prop2, H, val1, val2, graph2D=None):
    H = float(H)
    val1 = float(val1)
    val2 = float(val2)
    if prop1 == "DB" and prop2 == "SH":
        results = db_sh(H, val1, val2)
    elif prop1 == "DB" and prop2 == "RH":
        results = db_rh(H, val1, val2)
    elif prop1 == "DB" and prop2 == "ET":
        results = db_et(H, val1, val2)
    elif prop1 == "DB" and prop2 == "WB":
        results = db_wb(H, val1, val2)
    elif prop1 == "DB" and prop2 == "SV":
        results = db_sv(H, val1, val2)
    elif prop1 == "DB" and prop2 == "PV":
        results = db_pv(H, val1, val2)
    elif prop1 == "DB" and prop2 == "DP":
        results = db_dp(H, val1, val2)
    elif prop1 == "SH" and prop2 == "RH":
        results = sh_rh(H, val1, val2)
    elif prop1 == "SH" and prop2 == "ET":
        results = sh_et(H, val1, val2)
    elif prop1 == "SH" and prop2 == "WB":
        results = sh_wb(H, val1, val2)
    elif prop1 == "SH" and prop2 == "SV":
        results = sh_sv(H, val1, val2)
    elif prop1 == "RH" and prop2 == "ET":
        results = rh_et(H, val1, val2)
    elif prop1 == "RH" and prop2 == "WB":
        results = rh_wb(H, val1, val2)
    elif prop1 == "RH" and prop2 == "SV":
        results = rh_sv(H, val1, val2)
    elif prop1 == "RH" and prop2 == "PV":
        results = rh_pv(H, val1, val2)
    elif prop1 == "RH" and prop2 == "DP":
        results = rh_dp(H, val1, val2)
    elif prop1 == "ET" and prop2 == "SV":
        results = et_sv(H, val1, val2)
    elif prop1 == "ET" and prop2 == "PV":
        results = et_pv(H, val1, val2)
    elif prop1 == "ET" and prop2 == "DP":
        results = et_dp(H, val1, val2)
    elif prop1 == "WB" and prop2 == "SV":
        results = wb_sv(H, val1, val2)
    elif prop1 == "WB" and prop2 == "PV":
        results = wb_pv(H, val1, val2)
    elif prop1 == "WB" and prop2 == "DP":
        results = wb_dp(H, val1, val2)
    elif prop1 == "SV" and prop2 == "PV":
        results = sv_pv(H, val1, val2)
    elif prop1 == "SV" and prop2 == "DP":
        results = sv_dp(H, val1, val2)
    elif prop1 == "SH" and prop2 == "DB":
        results = db_sh(H, val2, val1)
    elif prop1 == "RH" and prop2 == "DB":
        results = db_rh(H, val2, val1)
    elif prop1 == "ET" and prop2 == "DB":
        results = db_et(H, val2, val1)
    elif prop1 == "WB" and prop2 == "DB":
        results = db_wb(H, val2, val1)
    elif prop1 == "SV" and prop2 == "DB":
        results = db_sv(H, val2, val1)
    elif prop1 == "PV" and prop2 == "DB":
        results = db_pv(H, val2, val1)
    elif prop1 == "DP" and prop2 == "DB":
        results = db_dp(H, val2, val1)
    elif prop1 == "RH" and prop2 == "SH":
        results = sh_rh(H, val2, val1)
    elif prop1 == "ET" and prop2 == "SH":
        results = sh_et(H, val2, val1)
    elif prop1 == "WB" and prop2 == "SH":
        results = sh_wb(H, val2, val1)
    elif prop1 == "SV" and prop2 == "SH":
        results = sh_sv(H, val2, val1)
    elif prop1 == "ET" and prop2 == "RH":
        results = rh_et(H, val2, val1)
    elif prop1 == "WB" and prop2 == "RH":
        results = rh_wb(H, val2, val1)
    elif prop1 == "SV" and prop2 == "RH":
        results = rh_sv(H, val2, val1)
    elif prop1 == "PV" and prop2 == "RH":
        results = rh_pv(H, val2, val1)
    elif prop1 == "DP" and prop2 == "RH":
        results = rh_dp(H, val2, val1)
    elif prop1 == "SV" and prop2 == "ET":
        results = et_sv(H, val2, val1)
    elif prop1 == "PV" and prop2 == "ET":
        results = et_pv(H, val2, val1)
    elif prop1 == "DP" and prop2 == "ET":
        results = et_dp(H, val2, val1)
    elif prop1 == "SV" and prop2 == "WB":
        results = wb_sv(H, val2, val1)
    elif prop1 == "PV" and prop2 == "WB":
        results = wb_pv(H, val2, val1)
    elif prop1 == "DP" and prop2 == "WB":
        results = wb_dp(H, val2, val1)
    elif prop1 == "PV" and prop2 == "SV":
        results = sv_pv(H, val2, val1)
    elif prop1 == "DP" and prop2 == "SV":
        results = sv_dp(H, val2, val1)
    else:
        print("Logic Error", "Unsupported property combination.")
    if graph2D:
        graph2D(H, results['ET'], results['PV'], results['RH'], results['SV'], results['WB'])
    return results
        

def getSaturationTemperature(P):
    T_data = [-60, -59, -58, -57, -56, -55, -54, -53, -52, -51, -50, -49, -48, -47, -46, -45, -44, -43, -42, -41, -40 , -39, -38, -37, -36, -35, -34, -33, -32, -31, -30, -29, -28, -27, -26, -25, -24, -23, -22, -21, -20, -19, -18, -17, -16, -15, -14, -13, -12, -11, -10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 122, 124, 126, 128, 130, 132, 134, 136, 138, 140, 142, 144, 146, 148, 150, 152, 154, 156, 158, 160];
    P_data = [0.00108, 0.00124, 0.00141, 0.00161, 0.00184, 0.00209, 0.00238, 0.00271, 0.00307, 0.00348, 0.00394, 0.00445, 0.00503, 0.00568, 0.00640, 0.00720, 0.00810, 0.00910, 0.01022, 0.01146, 0.01284, 0.01437, 0.01607, 0.01795, 0.02004, 0.02234, 0.02489, 0.02771, 0.03081, 0.03423, 0.03801, 0.04215, 0.04672, 0.05173, 0.05724, 0.06237, 0.06989, 0.07714, 0.08508, 0.09376, 0.10324, 0.11360, 0.12490, 0.13722, 0.15065, 0.16527, 0.18119, 0.19849, 0.21729, 0.23771, 0.25987, 0.28391, 0.30995, 0.33817, 0.36871, 0.40174, 0.43745, 0.47604, 0.51770, 0.56266, 0.61115, 0.6571, 0.7060, 0.7581, 0.8135, 0.8726, 0.9354, 1.0021, 1.0730, 1.1483, 1.2282, 1.3129, 1.4028, 1.4981, 1.5989, 1.7057, 1.8188, 1.9383, 2.0647, 2.1982, 2.3392, 2.4881, 2.6452, 2.8109, 2.9856, 3.1697, 3.3637, 3.5679, 3.7828, 4.0089, 4.2467, 4.4966, 4.7592, 5.0351, 5.3247, 5.6286, 5.9475, 6.2818, 6.6324, 6.9997, 7.3844, 7.7873, 8.2090, 8.6503, 9.1118, 9.5944, 10.0988, 10.6259, 11.1764, 11.7512, 12.3513, 12.9774, 13.6305, 14.3116, 15.0215, 15.7614, 16.5322, 17.3350, 18.1708, 19.0407, 19.9458, 20.8873, 21.8664, 22.8842, 23.9421, 25.0411, 26.1827, 27.3680, 28.5986, 29.8756, 31.2006, 32.5750, 34.0001, 35.4775, 37.0088, 38.5954, 40.2389, 41.9409, 43.7031, 45.5271, 47.4147, 49.3676, 51.3875, 53.4762, 55.6355, 57.8675, 60.1738, 62.5565, 65.0174, 67.5587, 70.1824, 72.8904, 75.6849, 78.5681, 81.5420, 84.6089, 87.7711, 91.0308, 94.3902, 97.8518, 101.4180, 105.0910, 108.8735, 112.7678, 116.7765, 120.9021, 125.1472, 129.5145, 134.0065, 138.6261, 143.3760, 148.2588, 153.2775, 158.4348, 163.7737, 169.1770, 174.7678, 180.5090, 186.4036, 192.4547, 198.6654, 211.5782, 225.1676, 239.4597, 254.4813, 270.2596, 286.8226, 304.1989, 322.4175, 341.5081, 361.5010, 382.4271, 404.3178, 427.2053, 451.1220, 476.1014, 502.1771, 529.3834, 557.7555, 587.3287, 618.1392];
    pchip_temp = PchipInterpolator(P_data, T_data)
    T_sat = pchip_temp(P)
    return T_sat

def getSaturationPressure(T):
    T_data = [-60, -59, -58, -57, -56, -55, -54, -53, -52, -51, -50, -49, -48, -47, -46, -45, -44, -43, -42, -41, -40 , -39, -38, -37, -36, -35, -34, -33, -32, -31, -30, -29, -28, -27, -26, -25, -24, -23, -22, -21, -20, -19, -18, -17, -16, -15, -14, -13, -12, -11, -10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 122, 124, 126, 128, 130, 132, 134, 136, 138, 140, 142, 144, 146, 148, 150, 152, 154, 156, 158, 160];
    P_data = [0.00108, 0.00124, 0.00141, 0.00161, 0.00184, 0.00209, 0.00238, 0.00271, 0.00307, 0.00348, 0.00394, 0.00445, 0.00503, 0.00568, 0.00640, 0.00720, 0.00810, 0.00910, 0.01022, 0.01146, 0.01284, 0.01437, 0.01607, 0.01795, 0.02004, 0.02234, 0.02489, 0.02771, 0.03081, 0.03423, 0.03801, 0.04215, 0.04672, 0.05173, 0.05724, 0.06237, 0.06989, 0.07714, 0.08508, 0.09376, 0.10324, 0.11360, 0.12490, 0.13722, 0.15065, 0.16527, 0.18119, 0.19849, 0.21729, 0.23771, 0.25987, 0.28391, 0.30995, 0.33817, 0.36871, 0.40174, 0.43745, 0.47604, 0.51770, 0.56266, 0.61115, 0.6571, 0.7060, 0.7581, 0.8135, 0.8726, 0.9354, 1.0021, 1.0730, 1.1483, 1.2282, 1.3129, 1.4028, 1.4981, 1.5989, 1.7057, 1.8188, 1.9383, 2.0647, 2.1982, 2.3392, 2.4881, 2.6452, 2.8109, 2.9856, 3.1697, 3.3637, 3.5679, 3.7828, 4.0089, 4.2467, 4.4966, 4.7592, 5.0351, 5.3247, 5.6286, 5.9475, 6.2818, 6.6324, 6.9997, 7.3844, 7.7873, 8.2090, 8.6503, 9.1118, 9.5944, 10.0988, 10.6259, 11.1764, 11.7512, 12.3513, 12.9774, 13.6305, 14.3116, 15.0215, 15.7614, 16.5322, 17.3350, 18.1708, 19.0407, 19.9458, 20.8873, 21.8664, 22.8842, 23.9421, 25.0411, 26.1827, 27.3680, 28.5986, 29.8756, 31.2006, 32.5750, 34.0001, 35.4775, 37.0088, 38.5954, 40.2389, 41.9409, 43.7031, 45.5271, 47.4147, 49.3676, 51.3875, 53.4762, 55.6355, 57.8675, 60.1738, 62.5565, 65.0174, 67.5587, 70.1824, 72.8904, 75.6849, 78.5681, 81.5420, 84.6089, 87.7711, 91.0308, 94.3902, 97.8518, 101.4180, 105.0910, 108.8735, 112.7678, 116.7765, 120.9021, 125.1472, 129.5145, 134.0065, 138.6261, 143.3760, 148.2588, 153.2775, 158.4348, 163.7737, 169.1770, 174.7678, 180.5090, 186.4036, 192.4547, 198.6654, 211.5782, 225.1676, 239.4597, 254.4813, 270.2596, 286.8226, 304.1989, 322.4175, 341.5081, 361.5010, 382.4271, 404.3178, 427.2053, 451.1220, 476.1014, 502.1771, 529.3834, 557.7555, 587.3287, 618.1392];
    pchip_press = PchipInterpolator(T_data, P_data)
    P_sat = pchip_press(T)
    return P_sat

def db_sh(H,DB,SH):
    PT=101.325*((1-(2.25577*(10**-5)*H))**5.2559)
    ET=(1.005*DB)+SH*(2500+(1.88*DB))
    PV=PT/((0.622/SH)+1)
    DP=getSaturationTemperature(PV)
    PS=getSaturationPressure(DB)
    RH=(PV/PS)*100
    SV=0.2871*(DB+273.15)/(PT-PV)
    WB=(-4.391976+(0.0198197*RH)+(0.526359*DB)+0.00730271*RH*DB)+(2.4315*(10**-4)*(RH**2))-(2.58101*(10**-5)*DB*(RH**2))
    return {"DB": DB, "SH": SH, "RH": RH, "ET": ET, "WB": WB, "SV": SV, "PV": PV, "DP": DP, "PT": PT}

def db_rh(H,DB,RH):
    PT=101.325*((1-(2.25577*(10**(-5))*H))**5.2559)
    PS=getSaturationPressure(DB)
    PV=(RH*PS)/100
    SV=0.2871*(DB+273.15)/(PT-PV)
    SH=0.622*(PV/(PT-PV))
    ET=(1.005*DB)+SH*(2500+(1.88*DB))
    DP=getSaturationTemperature(PV)
    WB=-4.391976+(0.0198197*RH)+(0.526359*DB)+(0.00730271*RH*DB)+(2.4315*(10**(-4))*(RH**(2)))-(2.58101*(10**(-5))*DB*(RH**(2)))
    return {"DB": DB, "SH": SH, "RH": RH, "ET": ET, "WB": WB, "SV": SV, "PV": PV, "DP": DP, "PT": PT}

def db_et(H,DB,ET):
    PT=101.325*((1-(2.25577*(10**(-5))*H))**5.2559)
    PS=getSaturationPressure(DB)
    SH=(ET-(1.005*DB))/(2500+(1.88*DB))
    PV=PT/((0.622/SH)+1)
    DP=getSaturationTemperature(PV)
    RH=(PV/PS)*100
    SV=0.2871*(DB+273.15)/(PT-PV)
    WB=-4.391976+(0.0198197*RH)+(0.526359*DB)+(0.00730271*RH*DB)+(2.4315*(10**(-4))*(RH**(2)))-(2.58101*(10**(-5))*DB*(RH**(2)))
    return {"DB": DB, "SH": SH, "RH": RH, "ET": ET, "WB": WB, "SV": SV, "PV": PV, "DP": DP, "PT": PT}

def db_wb(H,DB,WB):
    PT=101.325*((1-(2.25577*(10**(-5))*H))**5.2559)
    PS=getSaturationPressure(DB)
    PSWET=getSaturationPressure(WB)
    P=PT*((DB-WB)/1514)*(1+(WB/873))
    RH=((PSWET-P)/PS)*100
    PV=(RH*PS)/100
    SV=0.2871*(DB+273.15)/(PT-PV)
    SH=0.622*(PV/(PT-PV))
    ET=(1.005*DB)+SH*(2500+(1.88*DB))
    DP=getSaturationTemperature(PV)
    return {"DB": DB, "SH": SH, "RH": RH, "ET": ET, "WB": WB, "SV": SV, "PV": PV, "DP": DP, "PT": PT}

def db_sv(H,DB,SV):
    PT=101.325*((1-(2.25577*(10**(-5))*H))**5.2559)
    PS=getSaturationPressure(DB)
    PV=PT-(0.2871*(DB+273.15)/SV)
    SH=0.622*(PV/(PT-PV))
    ET=(1.005*DB)+SH*(2500+(1.88*DB))
    DP=getSaturationTemperature(PV)
    RH=(PV/PS)*100
    WB=-4.391976+(0.0198197*RH)+(0.526359*DB)+(0.00730271*RH*DB)+(2.4315*(10**(-4))*(RH**(2)))-(2.58101*(10**(-5))*DB*(RH**(2)))
    return {"DB": DB, "SH": SH, "RH": RH, "ET": ET, "WB": WB, "SV": SV, "PV": PV, "DP": DP, "PT": PT}

def db_pv(H,DB,PV):
    PT=101.325*((1-(2.25577*(10**(-5))*H))**5.2559)
    PS=getSaturationPressure(DB)
    RH=(PV/PS)*100
    SH=0.622*(PV/(PT-PV))
    ET=(1.005*DB)+SH*(2500+(1.88*DB))
    DP=getSaturationTemperature(PV)
    SV=0.2871*(DB+273.15)/(PT-PV)
    WB=-4.391976+(0.0198197*RH)+(0.526359*DB)+(0.00730271*RH*DB)+(2.4315*(10**(-4))*(RH**(2)))-(2.58101*(10**(-5))*DB*(RH**(2)))
    return {"DB": DB, "SH": SH, "RH": RH, "ET": ET, "WB": WB, "SV": SV, "PV": PV, "DP": DP, "PT": PT}

def db_dp(H,DB,DP):
    PT=101.325*((1-(2.25577*(10**(-5))*H))**5.2559)
    PS=getSaturationPressure(DB)
    PV=getSaturationPressure(DP)
    SH=0.622*(PV/(PT-PV))
    RH=(PV/PS)*100
    ET=(1.005*DB)+SH*(2500+(1.88*DB))
    SV=0.2871*(DB+273.15)/(PT-PV)
    WB=-4.391976+(0.0198197*RH)+(0.526359*DB)+(0.00730271*RH*DB)+(2.4315*(10**(-4))*(RH**(2)))-(2.58101*(10**(-5))*DB*(RH**(2)))
    return {"DB": DB, "SH": SH, "RH": RH, "ET": ET, "WB": WB, "SV": SV, "PV": PV, "DP": DP, "PT": PT}

def sh_rh(H,SH,RH):
    PT=101.325*((1-(2.25577*(10**(-5))*H))**5.2559)
    PV=PT/((0.622/SH)+1)
    PS=(PV/RH)*100
    DB=getSaturationTemperature(PS)
    ET=(1.005*DB)+SH*(2500+(1.88*DB))
    DP=getSaturationTemperature(PV)
    SV=0.2871*(DB+273.15)/(PT-PV)
    WB=-4.391976+(0.0198197*RH)+(0.526359*DB)+(0.00730271*RH*DB)+(2.4315*(10**(-4))*(RH**(2)))-(2.58101*(10**(-5))*DB*(RH**(2)))
    return {"DB": DB, "SH": SH, "RH": RH, "ET": ET, "WB": WB, "SV": SV, "PV": PV, "DP": DP, "PT": PT}

def sh_et(H,SH,ET):
    PT=101.325*((1-(2.25577*(10**(-5))*H))**5.2559)
    PV=PT/((0.622/SH)+1)
    DP=getSaturationTemperature(PV)
    DB=(ET-(2500*SH))/(1.005+(1.88*SH))
    PS=getSaturationPressure(DB)
    RH=(PV/PS)*100
    SV=0.2871*(DB+273.15)/(PT-PV)
    WB=-4.391976+(0.0198197*RH)+(0.526359*DB)+(0.00730271*RH*DB)+(2.4315*(10**(-4))*(RH**(2)))-(2.58101*(10**(-5))*DB*(RH**(2)))
    return {"DB": DB, "SH": SH, "RH": RH, "ET": ET, "WB": WB, "SV": SV, "PV": PV, "DP": DP, "PT": PT}

def sh_wb(H,SH,WB):
    PT=101.325*((1-(2.25577*(10**(-5))*H))**5.2559)
    PV=PT/((0.622/SH)+1)
    DP=getSaturationTemperature(PV)
    PSWET=getSaturationPressure(WB)
    DB=WB+((PSWET-PV)/(PT*0.00066))
    PS=getSaturationPressure(DB)
    RH=(PV/PS)*100
    ET=(1.005*DB)+SH*(2500+(1.88*DB))
    SV=0.2871*(DB+273.15)/(PT-PV)
    return {"DB": DB, "SH": SH, "RH": RH, "ET": ET, "WB": WB, "SV": SV, "PV": PV, "DP": DP, "PT": PT}

def sh_sv(H,SH,SV):
    PT=101.325*((1-(2.25577*(10**(-5))*H))**5.2559)
    PV=PT/((0.622/SH)+1)
    DP=getSaturationTemperature(PV)
    DB=(SV*(PT-PV)/0.2871)-273.15
    PS=getSaturationPressure(DB)
    ET=(1.005*DB)+SH*(2500+(1.88*DB))
    RH=(PV/PS)*100
    WB=-4.391976+(0.0198197*RH)+(0.526359*DB)+(0.00730271*RH*DB)+(2.4315*(10**(-4))*(RH**(2)))-(2.58101*(10**(-5))*DB*(RH**(2)))
    return {"DB": DB, "SH": SH, "RH": RH, "ET": ET, "WB": WB, "SV": SV, "PV": PV, "DP": DP, "PT": PT}

def rh_et(H,RH,ET):
    PT = 101.325 * ((1 - (2.25577 * (10 ** -5) * H)) ** 5.2559)  # in kPa
    RH_given = RH
    ET_given = ET
    
    # Constants
    PC = 22100
    TC = 647.30
    tolerance = 1e-6
    DB = 25  # initial dry-bulb temperature guess
    max_iter = 1000
    
    # Iterative calculation
    for iter_count in range(max_iter):
        T_k = DB + 273.15
        K = (4.39553 - 6.2442 * (T_k / 1000) + 9.953 * (T_k / 1000)**2
             - 5.151 * (T_k / 1000)**3)
        PS = PC * (10**(K * (1 - TC / T_k)))
        PV = (RH_given / 100) * PS
        SH = 0.622 * (PV / (PT - PV))
        ET_calculated = 1.005 * DB + SH * (2500 + 1.88 * DB)
        
        if abs(ET_calculated - ET_given) < tolerance:
            break
        
        DB = DB - 0.1 * (ET_calculated - ET_given)
    else:
        print("Did not converge within the maximum number of iterations.")
        return
    
    print(f"Converged to DB = {DB:.4f}°C in {iter_count + 1} iterations.")
    
    # Further calculations
    SH = (ET - (1.005 * DB)) / (2500 + (1.88 * DB))  # in kg/kg
    WB = (-4.391976 + 0.0198197 * RH + 0.526359 * DB + 0.00730271 * RH * DB +
          2.4315e-4 * (RH**2) - 2.58101e-5 * DB * (RH**2))
    PV = PT / ((0.622 / SH) + 1)  
    DP = getSaturationTemperature(PV)
    SV = 0.2871 * (DB + 273.15) / (PT - PV)  # in m^3/kg
    return {"DB": DB, "SH": SH, "RH": RH, "ET": ET, "WB": WB, "SV": SV, "PV": PV, "DP": DP, "PT": PT}

def rh_wb(H,RH,WB):
    PT = 101.325 * ((1 - (2.25577 * (10 ** -5) * H)) ** 5.2559)  # in kPa

    # Constants
    PC = 22100
    TC = 647.30
    tol = 1e-6
    max_iter = 100
    DB_min = -40
    DB_max = 65

    # Define the function to compute RH difference
    def compute_rh_diff(DB):
        WB_k = WB + 273.15
        DB_k = DB + 273.15

        PS_WB = PC * 10**(4.39553 - 6.2442 * (WB_k / 1000) + 9.953 * (WB_k / 1000)**2 - 5.151 * (WB_k / 1000)**3) * (1 - (TC / WB_k))
        PS_DB = PC * 10**(4.39553 - 6.2442 * (DB_k / 1000) + 9.953 * (DB_k / 1000)**2 - 5.151 * (DB_k / 1000)**3) * (1 - (TC / DB_k))

        RH_calc = ((PS_WB - PT * ((DB - WB) / 1514) * (1 + (WB / 873))) / PS_DB) * 100
        return RH - RH_calc

    # Iterative solution using binary search
    for iteration in range(max_iter):
        DB_mid = (DB_min + DB_max) / 2
        RH_diff_mid = compute_rh_diff(DB_mid)

        if abs(RH_diff_mid) < tol:
            print(f"Solution converged after {iteration + 1} iterations.")
            break
        if RH_diff_mid > 0:
            DB_max = DB_mid
        else:
            DB_min = DB_mid
    else:
        print("Did not converge within the maximum number of iterations.")
        return

    DB_solution = DB_mid
    print(f"The value of DB is: {DB_solution:.6f} °C")

    # Further calculations
    PS = getSaturationPressure(DB_solution)  # Placeholder function
    if PS is None:
        raise NotImplementedError("get_saturation_pressure function is not implemented.")
    DB=DB_solution
    PV = (RH * PS) / 100  # in kPa
    SH = 0.622 * (PV / (PT - PV))  # in kg/kg
    ET = (1.005 * DB_solution) + SH * (2500 + (1.88 * DB_solution))  # in kJ/kg
    SV = 0.2871 * (DB_solution + 273.15) / (PT - PV)  # in m³/kg
    DP = getSaturationTemperature(PV)  # Placeholder function
    return {"DB": DB, "SH": SH, "RH": RH, "ET": ET, "WB": WB, "SV": SV, "PV": PV, "DP": DP, "PT": PT}

def rh_sv(H,RH,SV):
    PT = 101.325 * ((1 - (2.25577 * (10 ** -5) * H)) ** 5.2559)  # in kPa

    # Define the functions for Newton-Raphson iteration
    def f(PS):
        return SV - (0.2871 * (
            6.54 
            + 14.526 * math.log(PS) 
            + 0.7389 * (math.log(PS))**2 
            + 0.0949 * (math.log(PS))**3 
            + 0.4569 * (PS)**0.1984 
            + 273.15
        ) / (PT - (RH * PS / 100)))

    def df(PS):
        return -(0.2871 * (
            (14.526 / PS) 
            + (2 * 0.7389 * math.log(PS) / PS) 
            + (3 * 0.0949 * (math.log(PS))**2 / PS) 
            + (0.4569 * 0.1984 * PS**(-0.8016))
        ) / (PT - (RH * PS / 100)))

    # Newton-Raphson iteration
    PS_guess = 1  # Initial guess for PS
    tol = 1e-6  # Tolerance for convergence
    max_iter = 1000  # Maximum iterations

    for iteration in range(max_iter):
        PS_new = PS_guess - f(PS_guess) / df(PS_guess)
        if abs(PS_new - PS_guess) < tol:
            print(f"Solution converged after {iteration + 1} iterations.")
            break
        PS_guess = PS_new
    else:
        print("Did not converge within the maximum number of iterations.")
        return

    PS_solution = PS_new
    print(f"The value of PS is: {PS_solution:.6f} kPa")

    # Further calculations
    PS = PS_solution
    DB = getSaturationTemperature(PS)  # Placeholder function
    if DB is None:
        raise NotImplementedError("get_saturation_temperature function is not implemented.")
    
    PV = (RH * PS) / 100  # in kPa
    DP = getSaturationTemperature(PV)  # Placeholder function

    SH = 0.622 * (PV / (PT - PV))  # in kg/kg
    ET = (1.005 * DB) + SH * (2500 + (1.88 * DB))  # in kJ/kg

    WB = (-4.391976 
          + 0.0198197 * RH 
          + 0.526359 * DB 
          + 0.00730271 * RH * DB 
          + 2.4315 * (10 ** -4) * (RH ** 2) 
          - 2.58101 * (10 ** -5) * DB * (RH ** 2))
    return {"DB": DB, "SH": SH, "RH": RH, "ET": ET, "WB": WB, "SV": SV, "PV": PV, "DP": DP, "PT": PT}

def rh_pv(H,RH,PV):
    PT=101.325*((1-(2.25577*(10**(-5))*H))**5.2559)
    PS=(PV/RH)*100
    DB=getSaturationTemperature(PS)
    SH=0.622*(PV/(PT-PV))
    WB=-4.391976+(0.0198197*RH)+(0.526359*DB)+(0.00730271*RH*DB)+(2.4315*(10**(-4))*(RH**(2)))-(2.58101*(10**(-5))*DB*(RH**(2)))
    DP=getSaturationTemperature(PV)
    ET=(1.005*DB)+SH*(2500+(1.88*DB))
    SV=0.2871*(DB+273.15)/(PT-PV)
    return {"DB": DB, "SH": SH, "RH": RH, "ET": ET, "WB": WB, "SV": SV, "PV": PV, "DP": DP, "PT": PT}

def rh_dp(H,RH,DP):
    PT=101.325*((1-(2.25577*(10**(-5))*H))**5.2559)
    PV=getSaturationPressure(DP)
    PS=(PV/RH)*100
    PS=(PV/RH)*100
    DB=getSaturationTemperature(PS)
    SH=0.622*(PV/(PT-PV))
    WB=-4.391976+(0.0198197*RH)+(0.526359*DB)+(0.00730271*RH*DB)+(2.4315*(10**(-4))*(RH**(2)))-(2.58101*(10**(-5))*DB*(RH**(2)))
    ET=(1.005*DB)+SH*(2500+(1.88*DB))
    SV=0.2871*(DB+273.15)/(PT-PV)
    return {"DB": DB, "SH": SH, "RH": RH, "ET": ET, "WB": WB, "SV": SV, "PV": PV, "DP": DP, "PT": PT}

def et_sv(H,ET,SV):
    PT = 101.325 * ((1 - (2.25577 * (10 ** -5) * H)) ** 5.2559)  # in kPa

    # Tolerance and iteration limits
    tol = 1e-6  # Convergence tolerance
    max_iter = 100  # Maximum iterations
    DB_min = -40  # Minimum dry-bulb temperature
    DB_max = 65   # Maximum dry-bulb temperature

    # Function to compute the difference in enthalpy
    def compute_ET_diff(DB):
        PV = PT - 0.2871 * (DB + 273.15) / SV
        SH = 0.622 * (PV / (PT - PV))
        ET_calculated = (1.005 * DB) + SH * (2500 + (1.88 * DB))
        return ET_calculated - ET

    # Bisection method to solve for DB
    for iteration in range(max_iter):
        f_min = compute_ET_diff(DB_min)
        f_max = compute_ET_diff(DB_max)

        if abs(f_min) < tol:
            DB_solution = DB_min
            print(f"Solution found at the lower bound: DB = {DB_solution:.6f} °C")
            break
        elif abs(f_max) < tol:
            DB_solution = DB_max
            print(f"Solution found at the upper bound: DB = {DB_solution:.6f} °C")
            break

        if f_min * f_max > 0:
            raise ValueError("No root found within the given interval.")

        DB_mid = (DB_min + DB_max) / 2
        f_mid = compute_ET_diff(DB_mid)

        if abs(f_mid) < tol:
            print(f"Solution converged after {iteration + 1} iterations.")
            DB_solution = DB_mid
            break

        if f_min * f_mid < 0:
            DB_max = DB_mid
        else:
            DB_min = DB_mid
    else:
        print("Max iterations reached. Solution may not have fully converged.")
        DB_solution = (DB_min + DB_max) / 2

    print(f"The value of DB is: {DB_solution:.6f} °C")

    # Calculations for psychrometric properties
    DB = DB_solution
    SH = (ET - (1.005 * DB)) / (2500 + (1.88 * DB))  # Specific humidity in kg/kg
    PV = PT / ((0.622 / SH) + 1)  # Partial vapor pressure in kPa

    # Compute RH and other properties
    PS = None  # Placeholder: Implement the logic for saturation pressure
    RH = (PV / PS) * 100 if PS else None  # Relative humidity in percentage
    DP = None  # Placeholder: Implement the logic for saturation temperature

    WB = (-4.391976 
          + 0.0198197 * RH 
          + 0.526359 * DB 
          + 0.00730271 * RH * DB 
          + 2.4315 * (10 ** -4) * (RH ** 2) 
          - 2.58101 * (10 ** -5) * DB * (RH ** 2)) if RH else None

    print(f"SH = {SH:.6f} kg/kg")
    print(f"PV = {PV:.6f} kPa")
    print(f"RH = {RH:.6f} %")
    print(f"DP = {DP}")
    print(f"WB = {WB}")
    return {"DB": DB, "SH": SH, "RH": RH, "ET": ET, "WB": WB, "SV": SV, "PV": PV, "DP": DP, "PT": PT}

def et_pv(H,ET,PV):
    PT=101.325*((1-(2.25577*(10**(-5))*H))**5.2559)
    SH=0.622*(PV/(PT-PV))
    DP=getSaturationTemperature(PV)
    DB=(ET-(2500*SH))/(1.005+(1.88*SH))
    PS=getSaturationPressure(DB)
    RH=(PV/PS)*100
    SV=0.2871*(DB+273.15)/(PT-PV)
    WB=-4.391976+(0.0198197*RH)+(0.526359*DB)+(0.00730271*RH*DB)+(2.4315*(10**(-4))*(RH**(2)))-(2.58101*(10**(-5))*DB*(RH**(2)))
    return {"DB": DB, "SH": SH, "RH": RH, "ET": ET, "WB": WB, "SV": SV, "PV": PV, "DP": DP, "PT": PT}

def et_dp(H,ET,DP):
    PT=101.325*((1-(2.25577*(10**(-5))*H))**5.2559)
    PV=getSaturationPressure(DP)
    SH=0.622*(PV/(PT-PV))
    DB=(ET-(2500*SH))/(1.005+(1.88*SH))
    PS=getSaturationPressure(DB)
    RH=(PV/PS)*100
    SV=0.2871*(DB+273.15)/(PT-PV)
    WB=-4.391976+(0.0198197*RH)+(0.526359*DB)+(0.00730271*RH*DB)+(2.4315*(10**(-4))*(RH**(2)))-(2.58101*(10**(-5))*DB*(RH**(2)))
    return {"DB": DB, "SH": SH, "RH": RH, "ET": ET, "WB": WB, "SV": SV, "PV": PV, "DP": DP, "PT": PT}

def wb_sv(H,WB,SV):
    PT = 101.325 * ((1 - (2.25577 * (10 ** -5) * H)) ** 5.2559)  # in kPa

    # Constants
    PC = 22100  # Critical pressure in kPa
    TC = 647.30  # Critical temperature in K
    epsilon = 1e-6  # Convergence tolerance
    DB = WB  # Initial guess for Dry Bulb Temperature
    error = 1  # Initial error

    while error > epsilon:
        T_db_k = DB + 273.15
        T_wb_k = WB + 273.15

        # Saturation pressure at DB and WB
        K_db = 4.39553 - 6.2442 * (T_db_k / 1000) + 9.953 * (T_db_k / 1000) ** 2 - 5.151 * (T_db_k / 1000) ** 3
        PS = PC * (10 ** (K_db * (1 - (TC / T_db_k))))

        K_wb = 4.39553 - 6.2442 * (T_wb_k / 1000) + 9.953 * (T_wb_k / 1000) ** 2 - 5.151 * (T_wb_k / 1000) ** 3
        PSWET = PC * (10 ** (K_wb * (1 - (TC / T_wb_k))))

        # Partial vapor pressure
        PV = PSWET - ((PT * (DB - WB) / 1514) * (1 + (WB / 873)))

        # Calculate specific volume
        SV_calc = 0.2871 * T_db_k / (PT - PV)

        # Relative humidity
        RH = (PV / PS) * 100

        # Update error
        error = abs(SV_calc - SV)

        if error > epsilon:
            DB = DB - 0.1 * (SV_calc - SV)

    print(f"The calculated Dry Bulb temperature (DB) is {DB:.4f} °C")

    # Additional calculations
    PS = None  # Placeholder: Implement the saturation pressure calculation logic
    PV = PT - (0.2871 * (DB + 273.15) / SV)  # in kPa
    SH = 0.622 * (PV / (PT - PV))  # Specific humidity in kg/kg
    DP = None  # Placeholder: Implement the dew point temperature calculation logic
    RH = (PV / PS) * 100 if PS else None  # Relative humidity in percentage
    ET = (1.005 * DB) + SH * (2500 + (1.88 * DB))  # Enthalpy in kJ/kg

    # Output calculated properties
    print(f"PV = {PV:.4f} kPa")
    print(f"SH = {SH:.4f} kg/kg")
    print(f"RH = {RH:.4f} %")
    print(f"ET = {ET:.4f} kJ/kg")
    print(f"DP = {DP}")
    return {"DB": DB, "SH": SH, "RH": RH, "ET": ET, "WB": WB, "SV": SV, "PV": PV, "DP": DP, "PT": PT}

def wb_pv(H,WB,PV):
    PT=101.325*((1-(2.25577*(10**(-5))*H))**5.2559)
    DP=getSaturationTemperature(PV)
    SH=0.622*(PV/(PT-PV))
    PSWET=getSaturationPressure(WB)
    DB=WB+((PSWET-PV)/(PT*0.00066))
    PS=getSaturationPressure(DB)
    RH=(PV/PS)*100
    ET=(1.005*DB)+SH*(2500+(1.88*DB))
    SV=0.2871*(DB+273.15)/(PT-PV)
    return {"DB": DB, "SH": SH, "RH": RH, "ET": ET, "WB": WB, "SV": SV, "PV": PV, "DP": DP, "PT": PT}

def wb_dp(H,WB,DP):
    PT=101.325*((1-(2.25577*(10**(-5))*H))**5.2559)
    PV=getSaturationPressure(DP)
    SH=0.622*(PV/(PT-PV))
    PSWET=getSaturationPressure(WB)
    DB=WB+((PSWET-PV)/(PT*0.00066))
    PS=getSaturationPressure(DB)
    RH=(PV/PS)*100
    ET=(1.005*DB)+SH*(2500+(1.88*DB))
    SV=0.2871*(DB+273.15)/(PT-PV)
    return {"DB": DB, "SH": SH, "RH": RH, "ET": ET, "WB": WB, "SV": SV, "PV": PV, "DP": DP, "PT": PT}

def sv_pv(H,SV,PV):
    PT=101.325*((1-(2.25577*(10**(-5))*H))**5.2559)
    DB=(SV*(PT-PV)/0.2871)-273.15
    PS=getSaturationPressure(DB)
    RH=(PV/PS)*100
    SH=0.622*(PV/(PT-PV))
    DP=getSaturationTemperature(PV)
    ET=(1.005*DB)+SH*(2500+(1.88*DB))
    WB=-4.391976+(0.0198197*RH)+(0.526359*DB)+(0.00730271*RH*DB)+(2.4315*(10**(-4))*(RH**(2)))-(2.58101*(10**(-5))*DB*(RH**(2)))
    return {"DB": DB, "SH": SH, "RH": RH, "ET": ET, "WB": WB, "SV": SV, "PV": PV, "DP": DP, "PT": PT}

def sv_dp(H,SV,DP):
    PT=101.325*((1-(2.25577*(10**(-5))*H))**5.2559)
    PV=getSaturationPressure(DP)
    SH=0.622*(PV/(PT-PV))
    DB=(SV*(PT-PV)/0.2871)-273.15
    PS=getSaturationPressure(DB)
    RH=(PV/PS)*100
    ET=(1.005*DB)+SH*(2500+(1.88*DB))
    WB=-4.391976+(0.0198197*RH)+(0.526359*DB)+(0.00730271*RH*DB)+(2.4315*(10**(-4))*(RH**(2)))-(2.58101*(10**(-5))*DB*(RH**(2)))
    return {"DB": DB, "SH": SH, "RH": RH, "ET": ET, "WB": WB, "SV": SV, "PV": PV, "DP": DP, "PT": PT}

def graph2D(H, ET, PV, RH, SV, WB):
    PT=101.325*((1-(2.25577*(10**-5)*H))**5.2559)
    x1 = np.linspace(-40, 65, 1000)
    y1 = (ET - (1.005 * x1)) / (2500 + (1.88 * x1))
    
    y_constant = 0.622 * (PV / (PT - PV))
    y2 = y_constant * np.ones_like(x1)
    
    PS = getSaturationPressure(x1)
    PV3 = (RH * PS) / 100
    y3 = 0.622 * (PV3 / (PT - PV3))
    
    PV4 = PT - (0.2871 * (x1 + 273.15) / SV)
    y4 = 0.622 * (PV4 / (PT - PV4))
    
    PSWET = getSaturationPressure(WB)
    P = PT * ((x1 - WB) / 1514) * (1 + (WB / 873))
    RH5 = ((PSWET - P) / PS) * 100
    PV5 = (RH5 * PS) / 100
    y5 = 0.622 * (PV5 / (PT - PV5))
    
    plt.plot(x1, y1, label='ET')
    plt.plot(x1, y2, label='PV')
    plt.plot(x1, y3, label='RH')
    plt.plot(x1, y4, label='SV')
    plt.plot(x1, y5, label='WB')
    
    plt.axis([-40, 65, 0, 0.0550])
    plt.xlabel('DB')
    plt.ylabel('SH')
    plt.title('ET, PV, RH, SV, WB')
    plt.legend()
    plt.grid()
    plt.show()

def graph3D(prop, val):
    x1 = np.linspace(-40, 65, 1000)  # Higher resolution
    y1 = np.linspace(79.495, 101.325, 1000)  # Higher resolution
    x1, y1 = np.meshgrid(x1, y1)

    if prop is None:
        return

    if val is None:
        return

    if prop == "ET":
        fig = plt.figure()
        ax = fig.add_subplot(111, projection='3d')  # Create a 3D plot
        z1 = (val - (1.005 * x1)) / (2500 + (1.88 * x1))
        ax.plot_surface(x1, y1, z1, cmap="viridis", edgecolor='none')
        ax.set_title("ET")

    elif prop == "PV":
        fig = plt.figure()
        ax = fig.add_subplot(111, projection='3d')  # Create a 3D plot
        z2 = 0.622 * (val / (y1 - val))
        ax.plot_surface(x1, y1, z2, cmap="viridis", edgecolor='none')
        ax.set_title("PV")

    elif prop == "RH":
        fig = plt.figure()
        ax = fig.add_subplot(111, projection='3d')  # Create a 3D plot
        PS = getSaturationPressure(x1)
        PV3 = (val * PS) / 100
        z3 = 0.622 * (PV3 / (y1 - PV3))
        ax.plot_surface(x1, y1, z3, cmap="viridis", edgecolor='none')
        ax.set_title("RH")

    elif prop == "SV":
        fig = plt.figure()
        ax = fig.add_subplot(111, projection='3d')  # Create a 3D plot
        PV4 = y1 - (0.2871 * (x1 + 273.15) / val)
        z4 = 0.622 * (PV4 / (y1 - PV4))
        ax.plot_surface(x1, y1, z4, cmap="viridis", edgecolor='none')
        ax.set_title("SV")

    elif prop == "WB":
        fig = plt.figure()
        ax = fig.add_subplot(111, projection='3d')  # Create a 3D plot
        PS = getSaturationPressure(x1)
        PSWET = getSaturationPressure(val)
        P = y1 * ((x1 - val) / 1514) * (1 + (val / 873))
        RH5 = ((PSWET - P) / PS) * 100
        PV5 = (RH5 * PS) / 100
        z5 = 0.622 * (PV5 / (y1 - PV5))
        ax.plot_surface(x1, y1, z5, cmap="viridis", edgecolor='none')
        ax.set_title("WB")

    ax.set_xlabel("DB")
    ax.set_ylabel("PT")
    ax.set_zlabel("SH")
    plt.colorbar(plt.cm.ScalarMappable(cmap="viridis"), ax=ax, shrink=0.5, aspect=10)
    plt.show()

def graph_full(H):
    if H is None:
        return

    PT = 101.325 * ((1 - (2.25577 * (10 ** -5) * H)) ** 5.2559)
    ET_values = np.arange(-20, 181, 10)
    PV_values = np.arange(0, 8.2317, 0.5)
    RH_values = np.arange(0, 101, 10)
    SV_values = np.arange(0.760, 1.021, 0.02)
    WB_values = np.arange(-10, 41, 5)

    x1 = np.linspace(-40, 65, 1000)

    plt.figure()
    for ET in ET_values:
        y1 = (ET - (1.005 * x1)) / (2500 + (1.88 * x1))
        plt.plot(x1, y1, 'r', label='ET' if ET == ET_values[0] else "")

    for PV in PV_values:
        y_constant = 0.622 * (PV / (PT - PV))
        y2 = y_constant * np.ones_like(x1)
        plt.plot(x1, y2, 'g', label='PV' if PV == PV_values[0] else "")

    for RH in RH_values:
        PS = getSaturationPressure(x1)
        PV3 = (RH * PS) / 100
        y3 = 0.622 * (PV3 / (PT - PV3))
        plt.plot(x1, y3, 'b', label='RH' if RH == RH_values[0] else "")

    for SV in SV_values:
        PV4 = PT - (0.2871 * (x1 + 273.15) / SV)
        y4 = 0.622 * (PV4 / (PT - PV4))
        plt.plot(x1, y4, 'm', label='SV' if SV == SV_values[0] else "")

    for WB in WB_values:
        PSWET = getSaturationPressure(WB)
        P = PT * ((x1 - WB) / 1514) * (1 + (WB / 873))
        RH5 = ((PSWET - P) / PS) * 100
        PV5 = (RH5 * PS) / 100
        y5 = 0.622 * (PV5 / (PT - PV5))
        plt.plot(x1, y5, 'c', label='WB' if WB == WB_values[0] else "")

    plt.axis([-40, 65, 0, 0.0550])
    plt.xlabel('DB')
    plt.ylabel('SH')
    plt.title('ET, PV, RH, SV, WB')
    plt.legend()
    plt.grid()
    plt.show()