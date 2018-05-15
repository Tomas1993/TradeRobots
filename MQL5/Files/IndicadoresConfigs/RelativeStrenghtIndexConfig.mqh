//+------------------------------------------------------------------+
//|                                  RelativeStrenghtIndexConfig.mqh |
//|                                  Copyright 2018, LeonardoPereira |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

#property copyright "Copyright 2018, LeonardoPereira"
#property link      "https://www.mql5.com"

//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+

class RSI_Configuration
{
   private:
      uint                             averagePeriod;
      
      double                           buyPercentage;
      double                           sellPercentage;
      
      ENUM_APPLIED_PRICE               applied_price;
   
   protected:
   
   public:   
      uint                             getAveragePeriod(void)        { return this.averagePeriod; }
      
      double                           getBuyPercentage(void)        { return this.buyPercentage; }
      
      double                           getSellPercentage(void)       { return this.sellPercentage; }
      
      ENUM_APPLIED_PRICE               getAppliedPrice(void)         { return this.applied_price; }
   
      void                             setRSIIndicator(
                                          uint                    _averagePeriod,
                                          double                  _buyPercentage,
                                          double                  _sellPercentage,
                                          ENUM_APPLIED_PRICE      _applied_price
                                       );
};

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void RSI_Configuration::setRSIIndicator(uint               _averagePeriod,
                                        double             _buyPercentage,
                                        double             _sellPercentage,
                                        ENUM_APPLIED_PRICE _applied_price)
{
   this.averagePeriod   = _averagePeriod;
   this.buyPercentage   = _buyPercentage;
   this.sellPercentage  = _sellPercentage;
   this.applied_price   = _applied_price;

   return;
}