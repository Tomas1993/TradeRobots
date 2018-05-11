/**
 *  @file    HelloMQL5.mq5
 *  @author: leonardo.pereira
 *  @version v1.0
 *  @date    13 de mar de 2018
 *  @brief  
 *           https://www.mql5.com/en/articles/770
             https://www.mql5.com/en/articles/4233?utm_campaign=articles.list&utm_medium=special&utm_source=mt5editor
             https://www.mql5.com/en/articles/4233
             http://www.algotrading.com.br/categoria-produto/premium/page/2/
 */
 
#property copyright "Copyright 2018, LeonardoPereira"
#property link      "https://www.linkedin.com/in/leonardowinterpereira/"
#property version   "1.00"

//+------------------------------------------------------------------+
//| Include                                                          |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Global expert object                                             |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//void OnStart(void)
//{
//   return;
//}
 
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit(void)
{                                         
   return INIT_SUCCEEDED;
}
 
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   // Stop event generation
   EventKillTimer();
   
   return;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
{
   return;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTimer(void)
{
   // Check if the terminal is connected to the trade server
   if(TerminalInfoInteger(TERMINAL_CONNECTED) == false)
   { 
      return;
   }
   
   return;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//void OnTrade(void)
//{
//   return;
//}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//void OnTradeTransaction(const MqlTradeTransaction&    trans,        // trade transaction structure 
//                        const MqlTradeRequest&        request,      // request structure 
//                        const MqlTradeResult&         result)       // result structure
//{
//   return;
//}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//double OnTester(void)
//{
//   return;
//}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//void OnTesterInit(void)
//{
//   return;
//}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//void OnTesterPass(void)
//{
//   return;
//}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//void OnTesterDeinit(void)
//{
//   return;
//}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//void OnBookEvent(const string& symbol)
//{
//   return;
//}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//void OnChartEvent(const int id,         // Event ID 
//                  const long& lparam,   // Parameter of type long event 
//                  const double& dparam, // Parameter of type double event 
//                  const string& sparam) // Parameter of type string events 
//{
//   return;
//}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//int OnCalculate (const int rates_total,      // size of the price[] array 
//                 const int prev_calculated,  // bars handled on a previous call 
//                 const int begin,            // where the significant data start from 
//                 const double& price[])      // array to calculate 
//{
//   return;
//}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//int OnCalculate (const int rates_total,      // size of input time series 
//                 const int prev_calculated,  // bars handled in previous call 
//                 const datetime& time[],     // Time 
//                 const double& open[],       // Open 
//                 const double& high[],       // High 
//                 const double& low[],        // Low 
//                 const double& close[],      // Close 
//                 const long& tick_volume[],  // Tick Volume 
//                 const long& volume[],       // Real Volume 
//                 const int& spread[])        // Spread 
//{
//   return;
//}