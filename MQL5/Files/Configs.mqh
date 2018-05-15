//+------------------------------------------------------------------+
//|                                                      Configs.mqh |
//|                                  Copyright 2018, LeonardoPereira |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

#property copyright "Copyright 2018, LeonardoPereira"
#property link      "https://www.mql5.com"

#include "Enumerators.mqh"

//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Timestamps used by the robot for every active group              |
//+------------------------------------------------------------------+

ENUM_TIMEFRAMES timeFrames_AcoesDayTrade[] = {PERIOD_M1,
                                              /*PERIOD_M10*/};
                                   
ENUM_TIMEFRAMES timeFrames_AcoesSwingTrade[] = {PERIOD_H1,
                                                PERIOD_H4,
                                                PERIOD_D1,
                                                PERIOD_W1,
                                                PERIOD_MN1};

ENUM_TIMEFRAMES timeFrames_ContratosFuturos[] = {};

ENUM_TIMEFRAMES timeFrames_FundosInvestimentosImobiliarios[] = {};

ENUM_TIMEFRAMES timeFrames_Opcoes[] = {}; 

//+------------------------------------------------------------------+
//| Indicators used by the robot                                     |
//+------------------------------------------------------------------+

ENUM_INDICATORS_ACOMPANHAMENTO_TENDENCIA  acompanhamentoTendenciaIndicators[] = {/*OBV,*/
                                                                                 /*MACD,*/
                                                                                 /*DIFUSOR_DE_FLUXO,*/
                                                                                 MOVING_AVERAGE,
                                                                                 /*HIGH_AND_LOW,*/
                                                                                 /*BOLLINGER_BANDS,*/};

ENUM_INDICADORES_CONTRA_TENDENCIA         indicadores_ContraTendencia[] = {/*RSI,*/};

ENUM_INDICATORS_VOLATILITY                volatilityIndicators[] = {/*AVERAGE_TRUE_RANGE,*/};