/*package rapport;

import utilitaire.Utilitaire;

import javax.ejb.Schedule;
import javax.ejb.Singleton;
import javax.ejb.Startup;
import java.sql.Date;

@Singleton
@Startup
public class RapportScheduler {

    @Schedule(hour = "17", minute = "30", second = "0", persistent = false)
    public void envoyerCRQuotidien() {
        try {
            Date daty = Utilitaire.dateDuJourSql();

            System.out.println("Début d'envoi automatique de CR : " + daty);

            Rapport rapport = new Rapport();
            rapport.sendMails(daty);

            System.out.println("Envoi terminé pour : " + daty);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}*/
package rapport;

import utilitaire.Utilitaire;
import javax.servlet.ServletContextListener;
import javax.servlet.ServletContextEvent;
import javax.servlet.annotation.WebListener;
import java.sql.Date;
import java.time.Duration;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

@WebListener
public class RapportScheduler implements ServletContextListener {

    private ScheduledExecutorService scheduler;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        scheduler = Executors.newSingleThreadScheduledExecutor();

        // Calcul du délai initial pour atteindre 17h30
        long initialDelayInSeconds = calculerDelaiInitial(17, 30, 0);

        // Planification de la tâche : s'exécute après le délai initial, puis toutes les 24 heures
        scheduler.scheduleAtFixedRate(this::envoyerCRQuotidien, initialDelayInSeconds, TimeUnit.DAYS.toSeconds(1), TimeUnit.SECONDS);
        System.out.println("RapportScheduler démarré. Prochain envoi planifié à 17:30.");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        if (scheduler != null) {
            scheduler.shutdown(); // Arrêt propre pour éviter les fuites de mémoire dans Tomcat
            System.out.println("RapportScheduler arrêté proprement.");
        }
    }

    public void envoyerCRQuotidien() {
        try {
            Date daty = Utilitaire.dateDuJourSql();

            System.out.println("Début d'envoi automatique de CR : " + daty);

            Rapport rapport = new Rapport();
//            rapport.sendMails(daty);

            System.out.println("Envoi terminé pour : " + daty);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Calcule le nombre de secondes restantes jusqu'à la prochaine occurrence de l'heure cible.
     */
    private long calculerDelaiInitial(int hour, int minute, int second) {
        LocalDateTime maintenant = LocalDateTime.now(ZoneId.systemDefault());
        LocalDateTime cible = maintenant.withHour(hour).withMinute(minute).withSecond(second).withNano(0);

        // Si l'heure de 17h30 est déjà passée aujourd'hui, on planifie pour demain
        if (maintenant.isAfter(cible)) {
            cible = cible.plusDays(1);
        }

        return Duration.between(maintenant, cible).getSeconds();
    }
}

