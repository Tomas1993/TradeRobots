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

struct SymbolStruct
{
   string   symbolName;
   
   long     symbolID;
   
   uchar    symbolWeight;
   
   bool     permissionToTrade;
   
#ifdef BOLLINGER_BANDS
   int      BB_Handle_High;
   int      BB_Handle_Low;
   
   double   BB_MinLot;
   double   BB_MaxLot;
   double   BB_Point;
   double   BB_ContractSize;
   
   uint     BB_DealNumber;
   datetime BB_Locked_bar_time;
#endif
};

struct Bollinger_Bands
{
   uint              movingAverage_Period;
   
   int               horizontalShift;
   
   double            standardDeviation;
};

union Indicators
{
   Bollinger_Bands   bollinger_bands;
};



//+------------------------------------------------------------------+
