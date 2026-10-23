package vente;

import bean.CGenUtil;
import bean.ClassMAPTable;
import bean.TypeObjet;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.Date;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.TextStyle;
import java.util.*;
import java.util.Locale;
import java.util.stream.Collectors;

public class CaCalendrier {
    String NOM_VUE_PROVINCE = "CA_JOUR_DETAILS_CA_V2";
    public static final String TOUTES_PROVINCES = "%";
    public static final String FORMAT_DATY = "dd/MM/yyyy";
    String nomAttributDaty="daty";
    String nomAttributMontant="montant";

    String[] listeMois;
    HashMap<String, Map<String, List<CaJourDetailPourCalendrier>>> caMensuels;
    String[] listeDate;
    HashMap<String, Vector> reservations;
    int [] jours;
    HashMap<String,Double[]> total = new HashMap<>();
    HashMap<String,String[]> bornesMois = new HashMap<>();

    TypeObjet[] provinces;

    public String getNomAttributMontant() {
        return nomAttributMontant;
    }

    public void setNomAttributMontant(String nomAttributMontant) {
        this.nomAttributMontant = nomAttributMontant;
    }

    public String getNomAttributDaty() {
        return nomAttributDaty;
    }

    public void setNomAttributDaty(String nomAttributDaty) {
        this.nomAttributDaty = nomAttributDaty;
    }

    public TypeObjet[] getProvinces() {
        return provinces;
    }

    public void setProvinces(TypeObjet[] provinces) {
        this.provinces = provinces;
    }

    public CaCalendrier(String dtMin, String dtMax) throws Exception {
        this(dtMin, dtMax, TOUTES_PROVINCES);
    }
    public CaCalendrier(String dtMin, String dtMax, String nTable,ClassMAPTable[] data,String nomAtrrDaty,String nomAttrMontant) throws Exception {
        Connection c=null;
        try {
            this.setNomAttributDaty(nomAtrrDaty);
            this.setNomAttributMontant(nomAttrMontant);
            c = new UtilDB().GetConn();
            this.jours = new int[31];
            for (int i = 0; i < 31; i++) {
                jours[i] = i+1;
            }
            if(nTable!=null&&nTable.compareToIgnoreCase("")!=0)NOM_VUE_PROVINCE=nTable;
            this.setListeDate(dtMin,dtMax);
            this.setReservations(data);
            this.setCaMensuels();
            this.setTotal();
        }
        catch (Exception e) {
            throw e;
        }
        finally {
            if(c!=null)c.close();
        }
    }

    public CaCalendrier(String dtMin, String dtMax, String province) throws Exception {
        Connection c=null;
        try {
            c = new UtilDB().GetConn();
            this.jours = new int[31];
            for (int i = 0; i < 31; i++) {
                jours[i] = i+1;
            }
            this.setListeDate(dtMin,dtMax);
            this.setReservations(dtMin,dtMax,province,c);
            this.setCaMensuels();
            this.setTotal();
            this.setProvinces((TypeObjet[]) CGenUtil.rechercher(new TypeObjet("province"), null, null, c, ""));
        }
        catch (Exception e) {
            throw e;
        }
        finally {
            if(c!=null)c.close();
        }
    }

    public int[] getJours() {
        return jours;
    }

    public void setJours(int[] jours) {
        this.jours = jours;
    }

    public String[] getListeDate() {
        return listeDate;
    }

    public void setListeDate(String dtMin,String dtMax) {
//        if(Utilitaire.diffJourDaty(dtMax,dtMin)<0)throw new Exception("Date sup inferieur a date Inf");
        int day = Utilitaire.diffJourDaty(dtMax, dtMin);
        String liste[]=new String[day];
        for (int i = 0; i < day; i++) {
            liste[i]=Utilitaire.formatterDaty(Utilitaire.ajoutJourDate(dtMin,i))  ;
        }
        this.listeDate = liste;
    }

    public HashMap<String, Vector> getReservations() {
        return reservations;
    }

    public void setReservations(ClassMAPTable[] listeDonnessTrie) throws Exception {
        if(listeDonnessTrie==null||listeDonnessTrie.length==0)return;
        String nomGetter = "get" + getNomAttributDaty().substring(0, 1).toUpperCase() + getNomAttributDaty().substring(1);

// Récupération de la méthode avant le Stream
        Method methodGetter = listeDonnessTrie[0].getClass().getMethod(nomGetter);

        /*reservations = Arrays.stream(listeDonnessTrie)
                .collect(Collectors.groupingBy(
                        obj -> {
                            try {
                                return Utilitaire.formatterDaty ((Date) methodGetter.invoke(obj));
                            } catch (Exception e) {
                                throw new RuntimeException(e);
                            }
                        },
                        HashMap::new,
                        Collectors.toCollection(Vector::new)
                ));*/
        reservations=new HashMap<>();
        for(int i=0;i<listeDonnessTrie.length;i++)
        {
            CaJourDetailPourCalendrier ca=new CaJourDetailPourCalendrier();
            ca.setDaty((Date)CGenUtil.getValeurFieldByMethod(listeDonnessTrie[i],this.getNomAttributDaty()));
            ca.setMontant((Double)CGenUtil.getValeurFieldByMethod(listeDonnessTrie[i],this.getNomAttributMontant()));
            Vector v=new Vector();
            v.add(ca);
            reservations.put(Utilitaire.formatterDaty(ca.getDaty()),v );
        }
    }

    public void setReservations(String dMin,String dMax,Connection c) throws Exception {
        this.setReservations(dMin,dMax,TOUTES_PROVINCES,c);
    }

    public void setReservations(String dMin,String dMax,String province,Connection c) throws Exception {
        CaJourDetailPourCalendrier res = new CaJourDetailPourCalendrier();
        res.setNomTable(NOM_VUE_PROVINCE);
        if(dMin==null||dMin.compareToIgnoreCase("")==0)dMin=Utilitaire.formatterDaty(Utilitaire.getDebutSemaine(Utilitaire.dateDuJourSql())) ;
        String[] colInt={this.nomAttributDaty};
        String[] valInt={dMin,dMax};
        this.reservations= CGenUtil.rechercher2D(res,colInt,valInt,this.getNomAttributDaty(),c,getFiltreProvince(province));
    }

    private String getFiltreProvince(String province) {
        if (province == null || province.trim().isEmpty()
                || province.compareToIgnoreCase(TOUTES_PROVINCES) == 0) {
            return "";
        }
        return " and provincelib = '" + province.replace("'", "''") + "' ";
    }

    public HashMap<String, Map<String, List<CaJourDetailPourCalendrier>>> getCaMensuels() {
        return caMensuels;
    }

    public void setCaMensuels(HashMap<String, Map<String, List<CaJourDetailPourCalendrier>>> caMensuels) {
        this.caMensuels = caMensuels;
    }

    public void setCaMensuels() {
        this.caMensuels = fusionParMois(this.getReservations());
        // Générer la liste complète de tous les mois entre min et max, même sans données
        this.listeMois = genererTousLesMois();

        // Initialiser les mois vides pour éviter les NullPointerException
        for (String mois : listeMois) {
            if (!caMensuels.containsKey(mois)) {
                caMensuels.put(mois, new HashMap<>());
            }
        }
    }

    private String[] genererTousLesMois() {
        if (listeDate == null || listeDate.length == 0) {
            return new String[]{};
        }

        DateTimeFormatter inputFormat = DateTimeFormatter.ofPattern("dd/MM/yyyy", Locale.FRANCE);
        DateTimeFormatter outputFormat = DateTimeFormatter.ofPattern("dd/MM/yyyy", Locale.FRANCE);
        LinkedHashMap<String, Boolean> moisMap = new LinkedHashMap<>();

        // Extraire la première et dernière date pour parcourir tous les mois
        LocalDate debut = LocalDate.parse(listeDate[0], inputFormat);
        LocalDate fin = LocalDate.parse(listeDate[listeDate.length - 1], inputFormat);

        // Parcourir chaque jour et ajouter le mois correspondant
        LocalDate courant = debut;
        while (!courant.isAfter(fin)) {
            String cleMois = getCleMois(courant);
            moisMap.putIfAbsent(cleMois, true);
            bornesMois.putIfAbsent(cleMois, new String[]{
                    courant.withDayOfMonth(1).format(outputFormat),
                    courant.withDayOfMonth(courant.lengthOfMonth()).format(outputFormat)
            });
            courant = courant.plusMonths(1).withDayOfMonth(1);
        }

        return moisMap.keySet().toArray(new String[]{});
    }

    public HashMap<String, Map<String,List<CaJourDetailPourCalendrier>>> fusionParMois(HashMap<String, Vector> caJour) {
        HashMap<String, Map<String,List<CaJourDetailPourCalendrier>>> resultat = new LinkedHashMap<>();
        DateTimeFormatter inputFormat = DateTimeFormatter.ofPattern("dd/MM/yyyy", Locale.FRANCE);
        for (String dateStr:listeDate) {

            Vector valeursJour = caJour.get(dateStr);
            if (valeursJour!=null){
                LocalDate date = LocalDate.parse(dateStr, inputFormat);

                String cleMois = getCleMois(date);
                String cleJour = String.valueOf(date.getDayOfMonth());
                resultat.putIfAbsent(cleMois, new HashMap<>());
                resultat.get(cleMois).putIfAbsent(cleJour, new ArrayList<>());
                resultat.get(cleMois).get(cleJour).addAll(valeursJour);
            }
        }
        return resultat;
    }

    public void setTotal() throws Exception {
        // total[0] - Montant Total
        // total[1] - Moyenne Total
        this.total = new HashMap<>();
        HashMap<String,Integer> nbJoursParMois = getNbJoursParMois();
        for (String dt : listeMois) {
            double montantTotal = 0;
            double moyenne = 0;
            Map<String, List<CaJourDetailPourCalendrier>> caJours = this.caMensuels.get(dt);
            for (Map.Entry<String, List<CaJourDetailPourCalendrier>> entry : caJours.entrySet()) {
                List<CaJourDetailPourCalendrier> v = entry.getValue();
                if (v != null) {
                    for (Object o:v){
                        CaJourDetailPourCalendrier res = (CaJourDetailPourCalendrier) o;
                        montantTotal += res.getMontant();
                    }
                }
            }
            Integer nbJours = nbJoursParMois.get(dt);
            if (nbJours != null && nbJours > 0) {
                moyenne = montantTotal / nbJours;
            }
            total.put(dt,new Double[]{montantTotal,moyenne});
        }
    }
    public void setTotal(String[] operation) throws Exception {
        // total[0] - Montant Total
        // total[1] - Moyenne Total
        this.total = new HashMap<>();
        HashMap<String,Integer> nbJoursParMois = getNbJoursParMois();
        for (String dt : listeMois) {
            Double[] ambany=new Double[operation.length];
            double montantTotal = 0;
            double moyenne = 0;
            Map<String, List<CaJourDetailPourCalendrier>> caJours = this.caMensuels.get(dt);

            Map.Entry<String, List<CaJourDetailPourCalendrier>> premierElement = caJours.entrySet().iterator().next();
            //String cle = premierElement.getKey();
            double min=premierElement.getValue().get(0).getMontant();
            double max=0;
            for(int i=0;i<operation.length;i++) {
                if(operation[i].compareToIgnoreCase("moyenne")==0) {
                    for (Map.Entry<String, List<CaJourDetailPourCalendrier>> entry : caJours.entrySet()) {
                        List<CaJourDetailPourCalendrier> v = entry.getValue();
                        if (v != null) {
                            for (Object o : v) {
                                CaJourDetailPourCalendrier res = (CaJourDetailPourCalendrier) o;
                                montantTotal += res.getMontant();
                            }
                        }
                    }

                    Integer nbJours = nbJoursParMois.get(dt);
                    if (nbJours != null && nbJours > 0) {
                        moyenne = montantTotal / nbJours;
                    }
                    ambany[i]=moyenne;
                }
                if(operation[i].compareToIgnoreCase("somme")==0) {
                    for (Map.Entry<String, List<CaJourDetailPourCalendrier>> entry : caJours.entrySet()) {
                        List<CaJourDetailPourCalendrier> v = entry.getValue();
                        if (v != null) {
                            for (Object o : v) {
                                CaJourDetailPourCalendrier res = (CaJourDetailPourCalendrier) o;
                                montantTotal += res.getMontant();
                            }
                        }
                    }
                    ambany[i]=montantTotal;
                }
                if(operation[i].compareToIgnoreCase("min")==0) {
                    for (Map.Entry<String, List<CaJourDetailPourCalendrier>> entry : caJours.entrySet()) {
                        List<CaJourDetailPourCalendrier> v = entry.getValue();
                        if (v != null) {
                            //min=v.get(0).getMontant();
                            for (CaJourDetailPourCalendrier o : v) {
                                System.out.println("AVANT IFFFF min ancien : "+Utilitaire.formaterAr(min) +" o getMontant "+Utilitaire.formaterAr(o.getMontant())  +" daty "+Utilitaire.formatterDaty(o.getDaty()));
                                if(o.getMontant()<min)
                                {
                                    min=o.getMontant();
                                }
                            }
                        }
                    }
                    ambany[i]=min;
                }
                if(operation[i].compareToIgnoreCase("max")==0) {
                    for (Map.Entry<String, List<CaJourDetailPourCalendrier>> entry : caJours.entrySet()) {
                        List<CaJourDetailPourCalendrier> v = entry.getValue();
                        if (v != null) {
                            max=v.get(0).getMontant();
                            for (CaJourDetailPourCalendrier o : v) {
                                if(o.getMontant()>max) max=o.getMontant();
                            }
                        }
                    }
                    ambany[i]=max;
                }

            }
            total.put(dt,ambany);
        }
    }


    private HashMap<String,Integer> getNbJoursParMois() {
        HashMap<String,Integer> resultat = new HashMap<>();
        if (listeDate == null) {
            return resultat;
        }
        DateTimeFormatter inputFormat = DateTimeFormatter.ofPattern("dd/MM/yyyy", Locale.FRANCE);
        for (String dateStr : listeDate) {
            String cleMois = getCleMois(LocalDate.parse(dateStr, inputFormat));
            Integer nb = resultat.get(cleMois);
            resultat.put(cleMois, nb == null ? 1 : nb + 1);
        }
        return resultat;
    }

    private String getCleMois(LocalDate date) {
        return date.getMonth().getDisplayName(TextStyle.FULL, Locale.FRANCE) + " " + date.getYear();
    }

    public HashMap<String, Double[]> getTotal() {
        return total;
    }
    public String[] getBornesMois(String cleMois) {
        return bornesMois.get(cleMois);
    }

    public String[] getListeMois() {
        return listeMois;
    }

    public void setListeMois(String[] listeMois) {
        this.listeMois = listeMois;
    }

    public String getDatyJour(int jour, String mois) {
        String[] bornes = getBornesMois(mois);
        if (bornes == null) {
            return null;
        }
        String daty = String.format("%02d", jour) + bornes[0].substring(2);
        if (!Utilitaire.isValidDate(daty, FORMAT_DATY)) {
            return null;
        }
        return daty;
    }

    public String getJourLibCourt(int jour, String mois) {
        String daty = getDatyJour(jour, mois);
        if (daty == null) {
            return "";
        }
        return Utilitaire.getJourDate(Utilitaire.stringDate(daty)).substring(0, 3) + ".";
    }

    public boolean isDimanche(int jour, String mois) throws Exception {
        String daty = getDatyJour(jour, mois);
        return daty != null && Utilitaire.isWeekEndSunday(Utilitaire.stringDate(daty));
    }

    public double getMontantJour(int jour, String mois) throws Exception {
        CaJourDetailPourCalendrier[] caJours = getReservationByTime(jour, mois);
        double montant = 0;
        if (caJours != null) {
            for (CaJourDetailPourCalendrier caJour : caJours) {
                //montant +=  caJour.getMontant();
                //double mDorg=caJour.getMontant();
                //double mCalc=Utilitaire.stringToDouble(CGenUtil.getValeurInsert(caJour,getNomAttributMontant()));
                montant+=caJour.getMontant();
            }
        }
        return montant;
    }

    public CaJourDetailPourCalendrier [] getReservationByTime(int jour, String mois) throws Exception {
        List<CaJourDetailPourCalendrier> res = this.caMensuels.get(mois).get(String.valueOf(jour));
        if (res == null) {
            return null;
        }
        return res.toArray(new CaJourDetailPourCalendrier[]{});
    }
}