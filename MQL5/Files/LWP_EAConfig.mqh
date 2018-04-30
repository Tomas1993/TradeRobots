//+------------------------------------------------------------------+
//|                                                     EAConfig.mqh |
//|                                  Copyright 2018, LeonardoPereira |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

#property copyright "Copyright 2018, LeonardoPereira"
#property link      "https://www.mql5.com"
#property version   "1.00"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class LWP_EAConfig
{
   private:
      float             brokerage_rate;
      
      long              leverage;
   
   protected:
   
   public:
      LWP_EAConfig();
      
      ~LWP_EAConfig();
      
      void              setBrokerageRate(float inputValue)                    { this.brokerage_rate = inputValue; }
      float             getBrokerageRate(void)                                { return this.brokerage_rate; }
      
      void              setLeverage(long inputValue)                          { this.leverage = inputValue; }
      long              getLeverage(void)                                     { return this.leverage; }
};

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
LWP_EAConfig::LWP_EAConfig()
{
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
LWP_EAConfig::~LWP_EAConfig()
{
}
//+------------------------------------------------------------------+
