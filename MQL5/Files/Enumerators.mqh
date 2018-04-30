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

enum MODUS_OPERANDIS
{
   ABRIR_INDICADOR,
   GET_FEEDBACK
};

enum GRUPO_INDICADORES
{
   ACOMPANHAMENTO_TENDENCIA,
   CONTRA_TENDENCIA,
   VOLATILIDADE
};

enum INDICADORES_ACOMPANHAMENTO_TENDENCIA
{
   OBV,
   MACD,
   DIFUSOR_DE_FLUXO,
   MEDIAS_MOVEIS,
   HIGH_AND_LOW,
   BANDAS_DE_BOLLINGER
};

enum INDICADORES_CONTRA_TENDENCIA
{
   IFR
};

enum INDICADORES_VOLATILIDADE
{
   ATR
};