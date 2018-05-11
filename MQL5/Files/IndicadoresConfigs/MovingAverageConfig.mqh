//+------------------------------------------------------------------+
//|                                         BollingerBandsConfig.mqh |
//|                                  Copyright 2018, LeonardoPereira |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

#property copyright "Copyright 2018, LeonardoPereira"
#property link      "https://www.mql5.com"

//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+

class Moving_Average_Configuration
{
   private:
      uint                             shortPeriod;
      uint                             mediumPeriod;
      uint                             longPeriod;
      
      int                              shift;
      
      ENUM_MA_METHOD                   method;
      
      ENUM_APPLIED_PRICE               applied_price;
   
   protected:
   
   public:   
      uint                             getShortPeriod(void)          { return this.shortPeriod; }
      uint                             getMediumPeriod(void)         { return this.mediumPeriod; }
      uint                             getLongPeriod(void)           { return this.longPeriod; }
   
      int                              getShift(void)                { return this.shift; }
      
      ENUM_MA_METHOD                   getMethod(void)               { return this.method; }
      
      ENUM_APPLIED_PRICE               getAppliedPrice(void)         { return this.applied_price; }
   
      void                             setMovingAverageIndicator(
                                          uint                    _shortPeriod,
                                          uint                    _mediumPeriod,
                                          uint                    _longPeriod,
                                          int                     _shift,
                                          ENUM_MA_METHOD          _method,
                                          ENUM_APPLIED_PRICE      _applied_price
                                       );
};

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Moving_Average_Configuration::setMovingAverageIndicator(uint               _shortPeriod,
                                                             uint               _mediumPeriod,
                                                             uint               _longPeriod,
                                                             int                _shift,
                                                             ENUM_MA_METHOD     _method,
                                                             ENUM_APPLIED_PRICE _applied_price)
{
   this.shortPeriod     = _shortPeriod;
   this.mediumPeriod    = _mediumPeriod;
   this.longPeriod      = _longPeriod;
   this.shift           = _shift;
   this.method          = _method;
   this.applied_price   = _applied_price;

   return;
}