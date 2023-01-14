class Utility{

  static String getSeparatedNumber(String strNum){

    final str=strNum.split('.');

    if(str[0].length<=3) return strNum;
    String total='';
    int counter=0;
    String minus='';

    for(int i=str[0].length-1;i>=0;i--){//141247
      if(str[0][i]=='.') continue;
      if(str[0][i]=='-') {
        minus='-';
        continue;
      }

        if(counter!=0&&counter%3==0){ // 1
          total = str[0][i]+','+total;
        }
        else {
          total = str[0][i]+total;
        }
        counter++;
      }

    if(str.length>1) total = minus+ total + '.${str[1]}';
    return total;
  }
}