package rapprochement;

import utilitaire.Utilitaire;
import utils.csv.CsvReader;

import java.io.InputStream;
import java.sql.Date;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;

public class ImportRelever {
    Map<String,String[]> titreCsv;
    Map<String,Integer> debutDeLigne;
    Map<String,String> colonneRequired;
    Map<String,String> delimiter;

    public static final String cle_fixe = "FIXE";

    public ImportRelever() {
        titreCsv = new HashMap<>();
        debutDeLigne = new HashMap<>();
        colonneRequired = new HashMap<>();
        delimiter = new HashMap<>();
        // Banque BNI
        titreCsv.put("CAI000237",new String[]{"titre1","titre2","titre3","titre4","titre5","titre6"});
        debutDeLigne.put("CAI000237",14);
        colonneRequired.put("CAI000237","titre1");
        delimiter.put("CAI000237",";");
        // Banque BMOI
        titreCsv.put("CAI000233",new String[]{"titre1","titre2","titre3","titre4","titre5","titre6"});
        debutDeLigne.put("CAI000233",14);
        colonneRequired.put("CAI000233","titre1");
        delimiter.put("CAI000233",";");
        // Banque BRED
        titreCsv.put("CAI000229",new String[]{"titre1","titre2","titre3","titre4","titre5","titre6","titre7","titre8","titre9","titre10","titre11","titre12","titre13","titre14"});
        debutDeLigne.put("CAI000229",1);
        colonneRequired.put("CAI000229","titre4");
        delimiter.put("CAI000229",";");
        // Banque MCB
        titreCsv.put("CAI000234",new String[]{"titre1","titre2","titre3","titre4","titre5","titre6","titre7"});
        debutDeLigne.put("CAI000234",26);
        colonneRequired.put("CAI000234","titre1");
        delimiter.put("CAI000234",",");
        // Banque BNI 2
        titreCsv.put("CAISS00001",new String[]{"titre1","titre2","titre3","titre4","titre5","titre6"});
        debutDeLigne.put("CAISS00001",14);
        colonneRequired.put("CAISS00001","titre1");
        delimiter.put("CAISS00001",";");
        // Canva standard
        titreCsv.put(cle_fixe,new String[]{"titre1","titre2","titre3","titre4","titre5","titre6"});
        debutDeLigne.put(cle_fixe,6);
        colonneRequired.put(cle_fixe,"titre1");
        delimiter.put(cle_fixe,";");
    }


    public Relever genererRelever(InputStream inputStream, String delimiter, String idCaisse, Date daty) throws Exception {
        Integer startLine = this.getDebutDeLigne().get(idCaisse);
        Relever relever = null;
        if (startLine != null) {
            relever = new Relever();
            relever.setDaty(daty);
            relever.setIdCaisse(idCaisse);
            Date dateDebut = null;
            Date dateFin = null;
            if (idCaisse.equals("CAI000237") || idCaisse.equals("CAI000233") || idCaisse.equals("CAISS00001")){
                List<Map<String,String>> dataDate = CsvReader.readCSV(inputStream,this.getDelimiter().get(idCaisse),2,"titre1",this.getTitreCsv().get(idCaisse));
                if (!dataDate.isEmpty()){
                    Map<String,String> dataMap = dataDate.get(0);
                    DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
                    dateDebut = Date.valueOf(LocalDate.parse(dataMap.get("titre2"),dateTimeFormatter));
                    dateFin = Date.valueOf(LocalDate.parse(dataMap.get("titre4"),dateTimeFormatter));
                }
            }
            if (idCaisse.equals("CAI000234")){
                List<Map<String,String>> dataDate = CsvReader.readCSV(inputStream,this.getDelimiter().get(idCaisse),22,"titre1",this.getTitreCsv().get(idCaisse));
                if (!dataDate.isEmpty()){
                    Map<String,String> dataMap = dataDate.get(0);
                    String [] tab = dataMap.get("titre1").split(" ");
                    DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("dd-MM-yyyy");
                    dateDebut = Date.valueOf(LocalDate.parse(tab[2].replace("(",""),dateTimeFormatter));
                    dateFin = Date.valueOf(LocalDate.parse(tab[4].replace(")",""),dateTimeFormatter));
                }
            }
            List<Map<String,String>> data = CsvReader.readCSV(inputStream,this.getDelimiter().get(idCaisse),startLine,this.getColonneRequired().get(idCaisse),this.getTitreCsv().get(idCaisse));

            relever.setDatyDebut(dateDebut);
            relever.setDatyFin(dateFin);
            List<ReleverDetail> releverDetails = new ArrayList<>();
            for (Map<String,String> row : data) {
                ReleverDetail releverDetail = new ReleverDetail();
                if (idCaisse.equals("CAI000237") || idCaisse.equals("CAI000233") || idCaisse.equals("CAISS00001")) {
                    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
                    String dateBrute = row.get("titre1").replace(" ","");
                    String dateValeurBrute = row.get("titre2").replace(" ","");
                    releverDetail.setDaty(Date.valueOf(LocalDate.parse(dateBrute,formatter)));
                    releverDetail.setDatyvaleur(Date.valueOf(LocalDate.parse(dateValeurBrute,formatter)));
                    releverDetail.setDesignation(row.get("titre3"));
                    releverDetail.setDebit(castToDouble(row.get("titre4")));
                    releverDetail.setCredit(castToDouble(row.get("titre5")));
                    releverDetail.setSolde(castToDouble(row.get("titre6")));
                }
                if (idCaisse.equals("CAI000229")) {
                    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
                    String dateBrute = row.get("titre4").replace(" ","").replace(".","/");
                    releverDetail.setDaty(Date.valueOf(LocalDate.parse(dateBrute,formatter)));
                    releverDetail.setDatyvaleur(Date.valueOf(LocalDate.parse(dateBrute,formatter)));
                    releverDetail.setDesignation(row.get("titre14"));
                    releverDetail.setDebit(castToDouble(row.get("titre6")));
                    releverDetail.setCredit(castToDouble(row.get("titre7")));
                    releverDetail.setSolde(castToDouble(row.get("titre10")));
                }
                if (idCaisse.equals("CAI000234")) {
                    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MMM-yyyy", Locale.ENGLISH);;
                    String dateBrute = row.get("titre1");
                    String dateValeurBrute = row.get("titre2");
                    releverDetail.setDaty(Date.valueOf(LocalDate.parse(dateBrute,formatter)));
                    releverDetail.setDatyvaleur(Date.valueOf(LocalDate.parse(dateValeurBrute,formatter)));
                    releverDetail.setDesignation(row.get("titre4"));
                    releverDetail.setDebit(castToDouble(row.get("titre5")));
                    releverDetail.setCredit(castToDouble(row.get("titre6")));
                    releverDetail.setSolde(castToDouble(row.get("titre7")));
                }
                releverDetails.add(releverDetail);
            }
            relever.setFille(releverDetails.toArray(new ReleverDetail[]{}));
        }
        else {
            throw new Exception("La caisse n'est pas prise en compte");
        }
        return relever;
    }

    public Relever genererReleverFixe(InputStream inputStream, String delimiter, String idCaisse, Date daty) throws Exception {
        byte[] contenu = CsvReader.copyInputStream(inputStream);
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");

        Relever relever = new Relever();
        relever.setDaty(daty);
        relever.setIdCaisse(idCaisse);

        List<Map<String,String>> dataDate = CsvReader.readCSVFromBytes(contenu,this.getDelimiter().get(cle_fixe),2,this.getColonneRequired().get(cle_fixe),this.getTitreCsv().get(cle_fixe));
        if (!dataDate.isEmpty()) {
            Map<String,String> dataMap = dataDate.get(0);
            relever.setDatyDebut(Date.valueOf(LocalDate.parse(dataMap.get("titre2").replace(" ",""),formatter)));
            relever.setDatyFin(Date.valueOf(LocalDate.parse(dataMap.get("titre4").replace(" ",""),formatter)));
        }

        List<Map<String,String>> data = CsvReader.readCSVFromBytes(contenu,this.getDelimiter().get(cle_fixe),this.getDebutDeLigne().get(cle_fixe),this.getColonneRequired().get(cle_fixe),this.getTitreCsv().get(cle_fixe));
        List<ReleverDetail> releverDetails = new ArrayList<>();
        for (Map<String,String> row : data) {
            ReleverDetail releverDetail = new ReleverDetail();
            releverDetail.setDaty(Date.valueOf(LocalDate.parse(row.get("titre1").replace(" ",""),formatter)));
            releverDetail.setDatyvaleur(Date.valueOf(LocalDate.parse(row.get("titre2").replace(" ",""),formatter)));
            releverDetail.setDesignation(row.get("titre3"));
            releverDetail.setDebit(castToDouble(row.get("titre4")));
            releverDetail.setCredit(castToDouble(row.get("titre5")));
            releverDetail.setSolde(castToDouble(row.get("titre6")));
            releverDetails.add(releverDetail);
        }
        relever.setFille(releverDetails.toArray(new ReleverDetail[]{}));
        return relever;
    }

    public double castToDouble (String val){
        String result = val != null && val.replace(" ","").isEmpty()==false ? val.replace(" ","").replace(".","") : "0";
        return Double.parseDouble(result.replace(",","."));
    }
    public Map<String, String[]> getTitreCsv() {
        return titreCsv;
    }

    public void setTitreCsv(Map<String, String[]> titreCsv) {
        this.titreCsv = titreCsv;
    }

    public Map<String, Integer> getDebutDeLigne() {
        return debutDeLigne;
    }

    public void setDebutDeLigne(Map<String, Integer> debutDeLigne) {
        this.debutDeLigne = debutDeLigne;
    }

    public Map<String, String> getColonneRequired() {
        return colonneRequired;
    }

    public void setColonneRequired(Map<String, String> colonneRequired) {
        this.colonneRequired = colonneRequired;
    }

    public Map<String, String> getDelimiter() {
        return delimiter;
    }

    public void setDelimiter(Map<String, String> delimiter) {
        this.delimiter = delimiter;
    }
}
