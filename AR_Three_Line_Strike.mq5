//+------------------------------------------------------------------+
//|                                         AR_Three_Line_Strike.mq5 |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Andrukas8"
#property link      "https://github.com/Andrukas8/AR_Three_Line_Strike_Indicator"
#property version   "1.00"
#property indicator_chart_window

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_plots   2
//--- plot UP
#property indicator_label1  "Strike Up"
#property indicator_type1   DRAW_ARROW
#property indicator_color1  clrLimeGreen
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//--- plot DN
#property indicator_label2  "Strike Down"
#property indicator_type2   DRAW_ARROW
#property indicator_color2  clrTomato
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1

//--- indicator buffers
double BufferUP[];
double BufferDN[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,BufferUP,INDICATOR_DATA);
   SetIndexBuffer(1,BufferDN,INDICATOR_DATA);
//--- setting a code from the Wingdings charset as the property of PLOT_ARROW
   PlotIndexSetInteger(0,PLOT_ARROW,241);
   PlotIndexSetInteger(1,PLOT_ARROW,242);
   PlotIndexSetInteger(0,PLOT_ARROW_SHIFT,-30);
   PlotIndexSetInteger(1,PLOT_ARROW_SHIFT,30);
//--- setting indicator parameters
   IndicatorSetString(INDICATOR_SHORTNAME,"ThreeLineStrike");
   IndicatorSetInteger(INDICATOR_DIGITS,Digits());
//--- setting buffer arrays as timeseries
   ArraySetAsSeries(BufferUP,true);
   ArraySetAsSeries(BufferDN,true);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//--- Checking the minimum number of bars for calculation
  
   if(rates_total<3) return 0;
//--- Checking and calculating the number of bars
   int limit=rates_total-prev_calculated;
   if(limit>1)
     {
      limit=rates_total-5;
      ArrayInitialize(BufferUP,EMPTY_VALUE);
      ArrayInitialize(BufferDN,EMPTY_VALUE);
     }
//--- Indexing arrays as timeseries
   ArraySetAsSeries(open,true);
   ArraySetAsSeries(close,true);
   
//--- Calculatind the indicator   
  for(int i=limit; i>=0 && !IsStopped(); i--)
     {
      bool strike_up=false;
      bool strike_dn=false;
      //--- find
      
      if(close[i] >= MathMax(close[i+1], MathMax(close[i+2], close[i+3])) &&
         close[i] >= MathMax(open[i+1], MathMax(open[i+2], open[i+3])) &&
         close[i] >= MathMin(open[i+1], MathMin(open[i+2], open[i+3])) &&
         open[i] <= MathMin(close[i+1], MathMin(close[i+2], close[i+3])) &&
         open[i] <= MathMax(close[i+1], MathMax(close[i+2], close[i+3])) &&
         open[i] <= MathMin(open[i+1], MathMin(open[i+2], open[i+3])) &&
         open[i] <= close[i] &&
         open[i+1] >= close[i+1] &&
         open[i+2] >= close[i+2] &&
         open[i+3] >= close[i+3])
      {      
       strike_up = true;
      }
            
      if(close[i] <= MathMax(close[i+1], MathMax(close[i+2], close[i+3])) &&
         close[i] <= MathMax(open[i+1], MathMax(open[i+2], open[i+3])) &&
         close[i] <= MathMin(open[i+1], MathMin(open[i+2], open[i+3])) &&
         open[i] >= MathMin(close[i+1], MathMin(close[i+2], close[i+3])) &&
         open[i] >= MathMax(close[i+1], MathMax(close[i+2], close[i+3])) &&
         open[i] >= MathMin(open[i+1], MathMin(open[i+2], open[i+3])) &&
         open[i] >= close[i] &&
         open[i+1] <= close[i+1] &&
         open[i+2] <= close[i+2] &&
         open[i+3] <= close[i+3])
      {      
       strike_dn = true;
      }
            
      //--- strikes
      
      if(strike_up)
         BufferUP[i]=close[i];
      else
         BufferUP[i]=EMPTY_VALUE;
      if(strike_dn)
         BufferDN[i]=close[i];
      else
         BufferDN[i]=EMPTY_VALUE;
     }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+