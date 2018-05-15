//+------------------------------------------------------------------+
//|                                                       Inputs.mqh |
//|                                  Copyright 2018, LeonardoPereira |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

#property copyright "Copyright 2018, LeonardoPereira"
#property link      "https://www.mql5.com"

//+------------------------------------------------------------------+
//| inputs                                                           |
//+------------------------------------------------------------------+

input float             iBrokerage_Rate               = 0.0;                     // Brokerage Rate (How much will you pay for every trade?)

input uint              iBB_Period                    = 12;                      // Bollinger Bands Period
input int               iBB_HorizontalShift           = 0;                       // Bollinger Bands Shift
input double            iBB_StandardDeviation         = 2.5;                     // Bollinger Bands Standard Deviation

input uint              iMA_ShortPeriod               = 20;                      // Moving Average Short Period 
input uint              iMA_MediumPeriod              = 35;                      // Moving Average Medium Period
input uint              iMA_LongPeriod                = 50;                      // Moving Average Long Period
input int               iMA_Shift                     = 0;                       // Moving Average Shift
input ENUM_MA_METHOD    iMA_Method                    = MODE_SMA;                // Moving Average Method

input uint              iRSI_AveragePeriod            = 35;                      // Relative Strength Index Average Period