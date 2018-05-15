//+------------------------------------------------------------------+
//|                                                  Enumerators.mqh |
//|                                  Copyright 2018, LeonardoPereira |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

#property copyright "Copyright 2018, LeonardoPereira"
#property link      "https://www.mql5.com"

//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+

enum ENUM_SYMBOL_GROUP
{
   ACOES_DAY_TRADE,
   ACOES_SWING_TRADE,
   CONTRATOS_FUTUROS,
   FUNDOS_INVESTIMENTOS_IMOBILIARIO,
   OPCOES
};

enum ENUM_AGRESSIDADE_OPERACOES
{
   CONSERVADOR,
   MODERADO,
   AGRESSIVO
};

enum ENUM_MODUS_OPERANDIS
{
   OPEN_INDICATOR,
   GET_FEEDBACK
};

enum ENUM_FEEDBACK_TYPE
{
   DO_NOTHING,
   BUY,
   SELL
};

enum ENUM_GRUPO_INDICADORES
{
   ACOMPANHAMENTO_TENDENCIA,
   CONTRA_TENDENCIA,
   VOLATILITY
};

enum ENUM_INDICATORS_ACOMPANHAMENTO_TENDENCIA
{
   OBV,                                            // Saldo de Volume
   MACD,                                           // Convergencia e Divergencia de Medias Moveis
   DIFUSOR_DE_FLUXO,
   MOVING_AVERAGE,                                 // Medias Moveis
   HIGH_AND_LOW,
   BOLLINGER_BANDS                                 // Bandas de Bollinger
};

enum ENUM_INDICADORES_CONTRA_TENDENCIA
{
   RELATIVE_STRENGTH_INDEX                         // IFR (Indice de Forca Relativa)
};

enum ENUM_INDICATORS_VOLATILITY
{
   AVERAGE_TRUE_RANGE
};