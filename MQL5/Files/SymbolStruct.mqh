//+------------------------------------------------------------------+
//|                                                 SymbolStruct.mqh |
//|                                  Copyright 2018, LeonardoPereira |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

#property copyright "Copyright 2018, LeonardoPereira"
#property link      "https://www.mql5.com"

//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+

#include "Configs.mqh"
#include "..\Files\Indicadores\BollingerBands.mqh"

struct SymbolStruct
{
   string            symbolName;
   
   long              symbolID;
   
   uchar             symbolWeight;
   
   bool              permissionToTrade;
   
   Bollinger_Bands   BollingerBands[NUM_TIMEFRAMES];
};
