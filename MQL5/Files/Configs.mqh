//+------------------------------------------------------------------+
//|                                                      Configs.mqh |
//|                                  Copyright 2018, LeonardoPereira |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

#property copyright "Copyright 2018, LeonardoPereira"
#property link      "https://www.mql5.com"

//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+

#define BOLLINGER_BANDS

ENUM_TIMEFRAMES timeFrames_AcoesDayTrade[] = {//PERIOD_M1,
                                              //PERIOD_M2,
                                              //PERIOD_M3,
                                              //PERIOD_M4,
                                              //PERIOD_M5,
                                              //PERIOD_M6,
                                              PERIOD_M10,
                                              //PERIOD_M12,
                                              //PERIOD_M15,
                                              //PERIOD_M20,
                                              PERIOD_M30,
                                              PERIOD_H1,
                                              //PERIOD_H2,
                                              //PERIOD_H3,
                                              //PERIOD_H4,
                                              //PERIOD_H6,
                                              //PERIOD_H8,
                                              //PERIOD_H12,
                                              PERIOD_D1,
                                              //PERIOD_W1,
                                              //PERIOD_MN1};
                                   
ENUM_TIMEFRAMES timeFrames_AcoesSwingTrade[] = {};

ENUM_TIMEFRAMES timeFrames_ContratosFuturos[] = {};                                        

ENUM_TIMEFRAMES timeFrames_FundosInvestimentosImobiliarios[] = {};

ENUM_TIMEFRAMES timeFrames_Opcoes[] = {}; 

//+------------------------------------------------------------------+
