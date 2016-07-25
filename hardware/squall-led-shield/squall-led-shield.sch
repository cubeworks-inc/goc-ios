EESchema Schematic File Version 2
LIBS:power
LIBS:device
LIBS:transistors
LIBS:conn
LIBS:linear
LIBS:regul
LIBS:74xx
LIBS:cmos4000
LIBS:adc-dac
LIBS:memory
LIBS:xilinx
LIBS:microcontrollers
LIBS:dsp
LIBS:microchip
LIBS:analog_switches
LIBS:motorola
LIBS:texas
LIBS:intel
LIBS:audio
LIBS:interface
LIBS:digital-audio
LIBS:philips
LIBS:display
LIBS:cypress
LIBS:siliconi
LIBS:opto
LIBS:atmel
LIBS:contrib
LIBS:valves
LIBS:squall
LIBS:squall-led-shield-cache
EELAYER 25 0
EELAYER END
$Descr USLetter 11000 8500
encoding utf-8
Sheet 1 1
Title "squall-led-shield"
Date "2016-07-21"
Rev "A"
Comp "CubeWorks"
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L R R1
U 1 1 5791553E
P 1150 3600
F 0 "R1" V 800 3600 50  0000 C CNN
F 1 "68Ω,0.5W" V 900 3600 50  0000 C CNN
F 2 "Resistors_SMD:R_0805" V 1000 3600 50  0000 C CNN
F 3 "" H 1150 3600 50  0000 C CNN
	1    1150 3600
	0    1    1    0   
$EndComp
$Comp
L SQUALL_HEADER J1
U 1 1 57916234
P 2950 850
F 0 "J1" H 2950 -700 60  0000 C CNN
F 1 "SQUALL_HEADER" H 2950 850 60  0000 C CNN
F 2 "Squall:SQUALL_HEADER" H 2950 850 60  0001 C CNN
F 3 "" H 2950 850 60  0000 C CNN
	1    2950 850 
	1    0    0    -1  
$EndComp
$Comp
L VCC #PWR01
U 1 1 579162D4
P 2250 1050
F 0 "#PWR01" H 2250 900 50  0001 C CNN
F 1 "VCC" H 2250 1200 50  0000 C CNN
F 2 "" H 2250 1050 50  0000 C CNN
F 3 "" H 2250 1050 50  0000 C CNN
	1    2250 1050
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR02
U 1 1 57916308
P 2400 1550
F 0 "#PWR02" H 2400 1300 50  0001 C CNN
F 1 "GND" H 2400 1400 50  0000 C CNN
F 2 "" H 2400 1550 50  0000 C CNN
F 3 "" H 2400 1550 50  0000 C CNN
	1    2400 1550
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR03
U 1 1 57916322
P 3500 1550
F 0 "#PWR03" H 3500 1300 50  0001 C CNN
F 1 "GND" H 3500 1400 50  0000 C CNN
F 2 "" H 3500 1550 50  0000 C CNN
F 3 "" H 3500 1550 50  0000 C CNN
	1    3500 1550
	1    0    0    -1  
$EndComp
NoConn ~ 3350 1450
NoConn ~ 2450 1850
NoConn ~ 2450 1950
NoConn ~ 2450 2050
NoConn ~ 2450 2150
NoConn ~ 2450 2250
NoConn ~ 3450 1850
NoConn ~ 3450 1950
NoConn ~ 3450 2050
NoConn ~ 3450 2150
NoConn ~ 3450 2250
$Comp
L C C1
U 1 1 57928D18
P 5550 2350
F 0 "C1" H 5665 2441 50  0000 L CNN
F 1 "4.7µF" H 5665 2350 50  0000 L CNN
F 2 "Capacitors_SMD:C_0603" H 5665 2259 50  0001 L CNN
F 3 "" H 5550 2350 50  0000 C CNN
	1    5550 2350
	1    0    0    -1  
$EndComp
$Comp
L C C2
U 1 1 57928D63
P 8650 2000
F 0 "C2" H 8765 2091 50  0000 L CNN
F 1 "4.7µF" H 8765 2000 50  0000 L CNN
F 2 "Capacitors_SMD:C_0603" H 8765 1909 50  0001 L CNN
F 3 "" H 8650 2000 50  0000 C CNN
	1    8650 2000
	1    0    0    -1  
$EndComp
$Comp
L INDUCTOR L1
U 1 1 57928DFE
P 6300 1700
F 0 "L1" V 6600 1800 50  0000 R CNN
F 1 "4.7µH" V 6500 1850 50  0000 R CNN
F 2 "Squall:INDUCTOR_VLF" V 6400 1700 50  0000 C CNN
F 3 "" H 6300 1700 50  0000 C CNN
	1    6300 1700
	0    -1   -1   0   
$EndComp
$Comp
L GND #PWR04
U 1 1 57929427
P 6850 2700
F 0 "#PWR04" H 6850 2450 50  0001 C CNN
F 1 "GND" H 6855 2527 50  0000 C CNN
F 2 "" H 6850 2700 50  0000 C CNN
F 3 "" H 6850 2700 50  0000 C CNN
	1    6850 2700
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR05
U 1 1 57929808
P 5550 2650
F 0 "#PWR05" H 5550 2400 50  0001 C CNN
F 1 "GND" H 5555 2477 50  0000 C CNN
F 2 "" H 5550 2650 50  0000 C CNN
F 3 "" H 5550 2650 50  0000 C CNN
	1    5550 2650
	1    0    0    -1  
$EndComp
$Comp
L R R2
U 1 1 5792A08A
P 1150 4950
F 0 "R2" V 1500 4950 50  0000 C CNN
F 1 "47Ω,0.5W" V 1400 4950 50  0000 C CNN
F 2 "Resistors_SMD:R_0805" V 1300 4950 50  0000 C CNN
F 3 "" H 1150 4950 50  0000 C CNN
	1    1150 4950
	0    -1   -1   0   
$EndComp
Text Label 3600 1150 0    60   ~ 0
~REG_SHDN
Text Label 3600 1250 0    60   ~ 0
LED_IR
Text Label 3600 1350 0    60   ~ 0
LED_WHITE
Text Label 6300 2200 2    60   ~ 0
~REG_SHDN
$Comp
L LED_HIGH_POWER D2
U 1 1 579524D4
P 1950 4950
F 0 "D2" H 1950 5255 50  0000 C CNN
F 1 "LED_HIGH_POWER" H 1950 5164 50  0000 C CNN
F 2 "Squall:CREE_XT-E" H 1950 5073 50  0000 C CNN
F 3 "" H 1950 4950 50  0000 C CNN
	1    1950 4950
	-1   0    0    -1  
$EndComp
Text Label 2100 5200 2    60   ~ 0
CREE_THERMAL
Text Label 1250 1400 2    60   ~ 0
CREE_THERMAL
NoConn ~ 1400 1400
Text Label 6300 2100 2    60   ~ 0
VCC
$Comp
L CubeWorks-Logo _1
U 1 1 579536BF
P 10200 700
F 0 "_1" H 10200 900 60  0001 C CNN
F 1 "CubeWorks-Logo" H 10200 1000 60  0001 C CNN
F 2 "Squall:CubeWorks_Logo-5mm" H 10225 825 60  0001 C CNN
F 3 "" H 10225 825 60  0001 C CNN
	1    10200 700 
	1    0    0    -1  
$EndComp
$Comp
L PWR_FLAG #FLG06
U 1 1 57916600
P 750 800
F 0 "#FLG06" H 750 895 50  0001 C CNN
F 1 "PWR_FLAG" H 750 980 50  0000 C CNN
F 2 "" H 750 800 50  0000 C CNN
F 3 "" H 750 800 50  0000 C CNN
	1    750  800 
	1    0    0    -1  
$EndComp
$Comp
L VCC #PWR07
U 1 1 57916658
P 750 950
F 0 "#PWR07" H 750 800 50  0001 C CNN
F 1 "VCC" H 750 1100 50  0000 C CNN
F 2 "" H 750 950 50  0000 C CNN
F 3 "" H 750 950 50  0000 C CNN
	1    750  950 
	-1   0    0    1   
$EndComp
$Comp
L PWR_FLAG #FLG08
U 1 1 5791661C
P 1200 800
F 0 "#FLG08" H 1200 895 50  0001 C CNN
F 1 "PWR_FLAG" H 1200 980 50  0000 C CNN
F 2 "" H 1200 800 50  0000 C CNN
F 3 "" H 1200 800 50  0000 C CNN
	1    1200 800 
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR09
U 1 1 5791663C
P 1200 950
F 0 "#PWR09" H 1200 700 50  0001 C CNN
F 1 "GND" H 1200 800 50  0000 C CNN
F 2 "" H 1200 950 50  0000 C CNN
F 3 "" H 1200 950 50  0000 C CNN
	1    1200 950 
	1    0    0    -1  
$EndComp
$Comp
L Q_2NMOS Q1
U 1 1 579646C6
P 2300 3950
F 0 "Q1" H 2489 4056 60  0000 L CNN
F 1 "Q_2NMOS" H 2489 3950 60  0000 L CNN
F 2 "TO_SOT_Packages_SMD:SC-70-6" H 2489 3844 60  0000 L CNN
F 3 "" H 2675 4050 60  0001 C CNN
	1    2300 3950
	1    0    0    -1  
$EndComp
$Comp
L Q_2NMOS Q1
U 2 1 57964728
P 2300 5450
F 0 "Q1" H 2489 5503 60  0000 L CNN
F 1 "Q_2NMOS" H 2489 5397 60  0000 L CNN
F 2 "" H 2675 5550 60  0001 C CNN
F 3 "" H 2675 5550 60  0001 C CNN
	2    2300 5450
	1    0    0    -1  
$EndComp
$Comp
L LED D1
U 1 1 57965013
P 1950 3600
F 0 "D1" H 1950 3905 50  0000 C CNN
F 1 "LED" H 1950 3814 50  0000 C CNN
F 2 "Squall:VSMY785X" H 1950 3723 50  0000 C CNN
F 3 "" H 1950 3600 50  0000 C CNN
	1    1950 3600
	-1   0    0    -1  
$EndComp
$Comp
L GND #PWR010
U 1 1 57965F53
P 2400 4250
F 0 "#PWR010" H 2400 4000 50  0001 C CNN
F 1 "GND" H 2405 4077 50  0000 C CNN
F 2 "" H 2400 4250 50  0000 C CNN
F 3 "" H 2400 4250 50  0000 C CNN
	1    2400 4250
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR011
U 1 1 57965F88
P 2400 5750
F 0 "#PWR011" H 2400 5500 50  0001 C CNN
F 1 "GND" H 2405 5577 50  0000 C CNN
F 2 "" H 2400 5750 50  0000 C CNN
F 3 "" H 2400 5750 50  0000 C CNN
	1    2400 5750
	1    0    0    -1  
$EndComp
Text Label 1000 3600 2    60   ~ 0
VREG
Text Label 1000 4950 2    60   ~ 0
VREG
Text Label 2100 3950 2    60   ~ 0
LED_IR
Text Label 2100 5450 2    60   ~ 0
LED_WHITE
$Comp
L R R3
U 1 1 57966E7D
P 8150 2000
F 0 "R3" H 8220 2046 50  0000 L CNN
F 1 "1.02MΩ" H 8220 1955 50  0000 L CNN
F 2 "Resistors_SMD:R_0603" H 8220 1909 50  0001 L CNN
F 3 "" H 8150 2000 50  0000 C CNN
	1    8150 2000
	1    0    0    -1  
$EndComp
$Comp
L R R4
U 1 1 57966EE9
P 8150 2400
F 0 "R4" H 8220 2446 50  0000 L CNN
F 1 "332kΩ" H 8220 2355 50  0000 L CNN
F 2 "Resistors_SMD:R_0603" V 8080 2400 50  0001 C CNN
F 3 "" H 8150 2400 50  0000 C CNN
	1    8150 2400
	1    0    0    -1  
$EndComp
$Comp
L AAT1217 VR1
U 1 1 57928866
P 6850 2150
F 0 "VR1" H 7050 1900 60  0000 C CNN
F 1 "AAT1217" H 7150 2400 60  0000 C CNN
F 2 "TO_SOT_Packages_SMD:SOT-23-6" H 6650 2150 60  0001 C CNN
F 3 "" H 6650 2150 60  0001 C CNN
	1    6850 2150
	1    0    0    -1  
$EndComp
Text Label 7350 2200 0    60   ~ 0
VREG_FEEDBACK
Text Label 7350 2100 0    60   ~ 0
VREG
$Comp
L C C3
U 1 1 57969500
P 9100 2000
F 0 "C3" H 9215 2046 50  0000 L CNN
F 1 "10µF" H 9215 1955 50  0000 L CNN
F 2 "Capacitors_SMD:C_0603" H 9215 1909 50  0001 L CNN
F 3 "" H 9100 2000 50  0000 C CNN
	1    9100 2000
	1    0    0    -1  
$EndComp
Connection ~ 8650 2600
Wire Wire Line
	9100 2600 9100 2150
Connection ~ 8650 1750
Wire Wire Line
	9100 1750 9100 1850
Connection ~ 8150 1750
Wire Wire Line
	8650 1750 8650 1850
Wire Wire Line
	8150 1750 8150 1850
Wire Wire Line
	8000 1750 8150 1750
Wire Wire Line
	8150 1750 8650 1750
Wire Wire Line
	8650 1750 9100 1750
Wire Wire Line
	8000 1700 8000 1750
Wire Wire Line
	8000 1750 8000 2100
Wire Wire Line
	8000 2100 7350 2100
Connection ~ 8150 2600
Wire Wire Line
	8150 2600 8150 2550
Connection ~ 8150 2200
Wire Wire Line
	7350 2200 8150 2200
Wire Wire Line
	8150 2150 8150 2200
Wire Wire Line
	8150 2200 8150 2250
Wire Wire Line
	6850 1700 6850 1750
Wire Wire Line
	6600 1700 6850 1700
Wire Wire Line
	6850 1700 7250 1700
Wire Wire Line
	2400 5650 2400 5750
Wire Wire Line
	2400 4950 2400 5250
Wire Wire Line
	2150 4950 2400 4950
Wire Wire Line
	2400 4150 2400 4250
Wire Wire Line
	2400 3600 2400 3750
Wire Wire Line
	2150 3600 2400 3600
Wire Wire Line
	1300 3600 1750 3600
Wire Wire Line
	1200 800  1200 950 
Wire Wire Line
	750  800  750  950 
Connection ~ 5550 2100
Wire Wire Line
	1250 1400 1400 1400
Wire Wire Line
	2100 5100 2150 5100
Wire Wire Line
	2150 5200 2100 5200
Wire Wire Line
	2150 5100 2150 5200
Wire Wire Line
	3350 1350 3600 1350
Wire Wire Line
	3350 1250 3600 1250
Wire Wire Line
	3350 1150 3600 1150
Wire Wire Line
	1300 4950 1750 4950
Connection ~ 5800 2100
Wire Wire Line
	5800 1700 6000 1700
Wire Wire Line
	5800 2100 5800 1700
Wire Wire Line
	5550 2100 5550 2200
Wire Wire Line
	5550 2100 5800 2100
Wire Wire Line
	5800 2100 6300 2100
Wire Wire Line
	5550 2650 5550 2500
Connection ~ 6850 2600
Wire Wire Line
	8650 2600 8650 2150
Wire Wire Line
	8150 2600 8650 2600
Wire Wire Line
	8650 2600 9100 2600
Wire Wire Line
	6850 2600 8150 2600
Wire Wire Line
	6850 2550 6850 2600
Wire Wire Line
	6850 2600 6850 2700
Connection ~ 2250 1150
Wire Wire Line
	2250 1150 2550 1150
Wire Wire Line
	2250 1250 2550 1250
Wire Wire Line
	2250 1050 2250 1150
Wire Wire Line
	2250 1150 2250 1250
Wire Wire Line
	3350 1550 3500 1550
Wire Wire Line
	2550 1550 2400 1550
$Comp
L D_Schottky D3
U 1 1 5796A1B4
P 7400 1700
F 0 "D3" H 7400 2006 50  0000 C CNN
F 1 "D_Schottky" H 7400 1915 50  0000 C CNN
F 2 "Diodes_SMD:SOD-123" H 7400 1824 50  0000 C CNN
F 3 "" H 7400 1700 50  0000 C CNN
	1    7400 1700
	-1   0    0    -1  
$EndComp
Connection ~ 6850 1700
Wire Wire Line
	7550 1700 8000 1700
Connection ~ 8000 1750
Text Label 2550 1450 2    60   ~ 0
SQUALL_5V
Text Label 2550 1350 2    60   ~ 0
SQUALL_5V
Text Label 6650 1700 0    60   ~ 0
VREG_SW
$EndSCHEMATC
