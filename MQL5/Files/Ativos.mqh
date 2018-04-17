//+------------------------------------------------------------------+
//|                                                        Acoes.mqh |
//|                                  Copyright 2018, LeonardoPereira |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

#property copyright "Copyright 2018, LeonardoPereira"
#property link      "https://www.mql5.com"

//+------------------------------------------------------------------+
//| defines & Includes                                               |
//+------------------------------------------------------------------+

#include "..\Files\SymbolStruct.mqh"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void populaAtivosAcoesDayTrade(SymbolStruct &symbolStruct[])
{  
   addSymbol(symbolStruct, "GRND3", 1, true); 
   addSymbol(symbolStruct, "PETR3", 1, true);
   //addSymbol(symbolStruct, "EZTC3", 1, true);
   //addSymbol(symbolStruct, "KROT3", 1, true);
   //addSymbol(symbolStruct, "ITUB3", 1, true);
   //addSymbol(symbolStruct, "BBDC3", 1, true);
   //addSymbol(symbolStruct, "WIZS3", 1, true);
   //addSymbol(symbolStruct, "BBSE3", 1, true);
   //addSymbol(symbolStruct, "EGIE3", 1, true);
   //addSymbol(symbolStruct, "PSSA3", 1, true);
   //addSymbol(symbolStruct, "MDIA3", 1, true);
   //addSymbol(symbolStruct, "CIEL3", 1, true);
   //addSymbol(symbolStruct, "ESTC3", 1, true);
   //addSymbol(symbolStruct, "ODPV3", 1, true);
    
   return;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void populaAtivosAcoesSwingTrade(SymbolStruct &symbolStruct[])
{  
   return;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void populaAtivosContratosFuturos(SymbolStruct &symbolStruct[])
{  
   return;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void populaAtivosFundosDeInvestimentosImobiliarios(SymbolStruct &symbolStruct[])
{  
   return;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void populaAtivosOpcoes(SymbolStruct &symbolStruct[])
{  
   return;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void addSymbol(SymbolStruct   &symbolStruct[],
               string         nome,
               uchar          peso,
               bool           permissaoTrade)
{
   static short posicao = 0;
   
   symbolStruct[posicao].symbolName          = nome;
   symbolStruct[posicao].symbolWeight        = peso;
   symbolStruct[posicao].permissionToTrade   = permissaoTrade;
   
   posicao++;
   
   return;
}
