package rapport;

import utilitaire.Utilitaire;

import javax.ejb.Schedule;
import javax.ejb.Singleton;
import javax.ejb.Startup;
import java.sql.Date;

@Singleton
@Startup
public class NewRapportScheduler {

    @Schedule(hour = "14", minute = "58", second = "0", persistent = false)
    public void envoyerCRQuotidien() {
        try {
            System.out.println("Début d'envoi automatique de CR : ");
            Date datejour = Utilitaire.dateDuJourSql();
            Date datetest = Date.valueOf("2026-07-30");
            CRJournalier crJournalier = new CRJournalier();
            crJournalier.sendPageEmail(datejour);

            System.out.println("Envoi terminé ");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
