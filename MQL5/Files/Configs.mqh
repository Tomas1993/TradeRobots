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

ENUM_TIMEFRAMES timeFrames_AcoesDayTrade[] = {PERIOD_M1,
                                              PERIOD_M10};
                                   
ENUM_TIMEFRAMES timeFrames_AcoesSwingTrade[] = {};

ENUM_TIMEFRAMES timeFrames_ContratosFuturos[] = {};

ENUM_TIMEFRAMES timeFrames_FundosInvestimentosImobiliarios[] = {};

ENUM_TIMEFRAMES timeFrames_Opcoes[] = {}; 

enum SYMBOL_GROUP
{
   ACOES_DAY_TRADE,
   ACOES_SWING_TRADE,
   CONTRATOS_FUTUROS,
   FUNDOS_INVESTIMENTOS_IMOBILIARIO,
   OPCOES
};

enum AGRESSIDADE_OPERACOES
{
   CONSERVADOR,
   MODERADO,
   AGRESSIVO
};

//+------------------------------------------------------------------+
