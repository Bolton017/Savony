package rapport;

import java.sql.Date;

public class MainRapport {
    public static void main(String[] args)throws Exception{
        try{
            Date date = new Date(124, 5, 15);
			date.setDate(date.getDate()-1);
//            Rapport.sendMail(date);

            Date dateDuJour = new Date(124, 5, 15);
			if(dateDuJour.getDate()==3){
                int mois = dateDuJour.getMonth();
                int annee = dateDuJour.getYear()+1900;
                if(mois == 0){
                    mois = 12;
                    annee--;
                }
//                RapportMensuel2.sendMail(mois, annee);
            }
        }catch(Exception e){
            e.printStackTrace();
            throw e;
        }
    }
}
