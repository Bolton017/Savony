package maintenance.utils;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.TemporalAdjusters;
import java.util.ArrayList;
import java.util.List;

public class CalendarUtil {

    public static String[] getDebutEtFinDeSemaine(String dateStr) {
        String[] debutEtFinDeSemaine = new String[4];
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");

        // Conversion de la chaîne vers LocalDate
        LocalDate date = LocalDate.parse(dateStr, formatter);

        // Début et fin de la semaine courante
        LocalDate debutSemaine = date.with(TemporalAdjusters.previousOrSame(DayOfWeek.MONDAY));
        LocalDate finSemaine = date.with(TemporalAdjusters.nextOrSame(DayOfWeek.SUNDAY));

        // Dernier jour de la semaine précédente (dimanche avant lundi courant)
        LocalDate dernierJourSemainePrecedente = debutSemaine.minusDays(1);

        // Premier jour de la semaine suivante (lundi après dimanche courant)
        LocalDate premierJourSemaineSuivante = finSemaine.plusDays(1);

        // Remplissage du tableau
        debutEtFinDeSemaine[0] = debutSemaine.format(formatter);
        debutEtFinDeSemaine[1] = finSemaine.format(formatter);
        debutEtFinDeSemaine[2] = dernierJourSemainePrecedente.format(formatter);
        debutEtFinDeSemaine[3] = premierJourSemaineSuivante.format(formatter);

        return debutEtFinDeSemaine;
    }

    public static String[] getDebutEtFinDuMois(String dateStr) {
        String[] debutEtFinDeSemaine = new String[4];
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");

        // Conversion de la chaîne vers LocalDate
        LocalDate date = LocalDate.parse(dateStr, formatter);

        // Début et fin de la semaine courante
        LocalDate debutSemaine = date.with(TemporalAdjusters.firstDayOfMonth());
        LocalDate finSemaine = date.with(TemporalAdjusters.lastDayOfMonth());

        // Dernier jour de la semaine précédente (dimanche avant lundi courant)
        LocalDate dernierJourSemainePrecedente = debutSemaine.minusDays(1);

        // Premier jour de la semaine suivante (lundi après dimanche courant)
        LocalDate premierJourSemaineSuivante = finSemaine.plusDays(1);

        // Remplissage du tableau
        debutEtFinDeSemaine[0] = debutSemaine.format(formatter);
        debutEtFinDeSemaine[1] = finSemaine.format(formatter);
        debutEtFinDeSemaine[2] = dernierJourSemainePrecedente.format(formatter);
        debutEtFinDeSemaine[3] = premierJourSemaineSuivante.format(formatter);

        return debutEtFinDeSemaine;
    }

    public static String getMonthName (int numMois){
        String [] mois = new String[]{"Janvier","F&eacute;vrier","Mars","Avril","Mais","Juin","Juillet","Ao&ucirc;t","Septembre","Octobre","Novembre","D&eacute;cembre"};
        return mois[numMois-1];
    }

    public static boolean isValidTime(String time) {
        time = formatTimeToHMS(time);
        // Expression régulière pour le format HH:MM:SS
        String regex = "^([01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$";
        return time != null && time.matches(regex);
    }

    public static String formatTimeToHMS(String time) {
        // Expression régulière pour le format HH:MM:SS
        if (time!=null){
            String [] tab = time.split(":");
            String regex = "^([01]\\d|2[0-3]):[0-5]\\d";
            if (time != null && time.matches(regex)) {
                if (tab.length == 2){
                    time += ":00";
                }
            }
        }
        return time;
    }

    public static int HMSToSecond(String heure){
        if (heure!=null){
            heure = formatTimeToHMS(heure);
            LocalTime time = LocalTime.parse(heure);
            return time.toSecondOfDay();
        }
        return 0;
    }

    public static List<LocalDate> getDatesAvantDansSemaine(LocalDate dateReference) {
        List<LocalDate> dates = new ArrayList<>();

        // Trouver le lundi de la même semaine
        LocalDate debutSemaine = dateReference.with(DayOfWeek.MONDAY);

        // Parcourir du lundi jusqu’au jour précédent la date de référence
        LocalDate d = debutSemaine;
        while (d.isBefore(dateReference)) {
            dates.add(d);
            d = d.plusDays(1);
        }

        return dates;
    }
}
