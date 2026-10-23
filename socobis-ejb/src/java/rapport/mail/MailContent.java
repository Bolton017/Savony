package rapport.mail;

import bean.CGenUtil;
import bean.ClassMAPTable;
import rapport.mapping.CRContent;
import rapport.mapping.CRContentFille;
import rapport.utilitaire.UtilitaireCR;
import utilitaire.UtilDB;

import java.sql.Connection;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

public class MailContent {

    private String titre;

    private String paragraphe;

    private ClassMAPTable mapping;

    private String[] libEntete;

    private String[] libEnteteAffiche;

    private String[] colSomme;

    private String colDate;

    private int graphe;

    public String getTitre() {
        return titre;
    }

    public void setTitre(String titre) {
        this.titre = titre;
    }

    public String getParagraphe() {
        return paragraphe;
    }

    public void setParagraphe(String paragraphe) {
        this.paragraphe = paragraphe;
    }

    public ClassMAPTable getMapping() {
        return mapping;
    }

    public void setMapping(ClassMAPTable mapping) {
        this.mapping = mapping;
    }

    public String[] getLibEntete() {
        return libEntete;
    }

    public void setLibEntete(String[] libEntete) {
        this.libEntete = libEntete;
    }

    public String[] getLibEnteteAffiche() {
        return libEnteteAffiche;
    }

    public void setLibEnteteAffiche(String[] libEnteteAffiche) {
        this.libEnteteAffiche = libEnteteAffiche;
    }

    public String[] getColSomme() {
        return colSomme;
    }

    public void setColSomme(String[] colSomme) {
        this.colSomme = colSomme;
    }

    public String getColDate() {
        return colDate;
    }

    public void setColDate(String colDate) {
        this.colDate = colDate;
    }

    public int getGraphe() {
        return graphe;
    }

    public void setGraphe(int graphe) {
        this.graphe = graphe;
    }

    public static MailContent transformerCRtoMail(CRContent crContent, Connection c)throws Exception{

        if(c==null){
            c = new UtilDB().GetConn();
        }

        MailContent mailContent = new MailContent();

        mailContent.setTitre(crContent.getTitre());

        mailContent.setParagraphe(crContent.getParagraphe());


        String classe = crContent.getMapping();
        ClassMAPTable map = (ClassMAPTable) (Class.forName(classe).newInstance());
        map.setNomTable(crContent.getVue());

        mailContent.setMapping(map);

        transformerFilleToMail(mailContent, crContent, c);

        mailContent.setGraphe(crContent.getGraphe());

        return mailContent;
    }

    public static void transformerFilleToMail(MailContent mailContent, CRContent crContent, Connection c) throws Exception{

        if(c==null){
            c = new UtilDB().GetConn();
        }

        CRContentFille[] crContentFilles = (CRContentFille[]) crContent.getFille("CRCONTENTFILLE", c, "");

        List<String> libEnteteList = new ArrayList<String>();
        List<String> libEnteteAfficherList = new ArrayList<String>();
        List<String> colSommeList = new ArrayList<String>();
        String colDate = "";

        String temp = "";
        for (int i = 0; i < crContentFilles.length; i++) {
            if(!crContentFilles[i].getLibEntete().equals("")){
                temp = crContentFilles[i].getLibEntete();

                libEnteteList.add(temp);

                if(crContentFilles[i].getColSomme()==1){
                    colSommeList.add(crContentFilles[i].getLibEntete());
                }

                if(crContentFilles[i].getColDate()==1){
                    colDate = temp;
                }

                if(crContentFilles[i].getLibEnteteAfficher()!=null && !crContentFilles[i].getLibEnteteAfficher().equals("")) {
                    temp = crContentFilles[i].getLibEnteteAfficher();
                }
                libEnteteAfficherList.add(temp);
            }
        }

        String[] libEntete = libEnteteList.toArray(new String[0]);
        String[] libEnteteAffiche = libEnteteAfficherList.toArray(new String[0]);
        String[] colSomme = colSommeList.toArray(new String[0]);

        mailContent.setLibEntete(libEntete);
        mailContent.setLibEnteteAffiche(libEnteteAffiche);
        mailContent.setColSomme(colSomme);
        mailContent.setColDate(colDate);
    }

    public String genererAWhere(int nature, Date daty)throws Exception{
        if(this.getColDate() == null || this.getColDate().equals("")){
            return "";
        }

        String aWhere = " and "+this.getColDate();
        if(nature == 1){
            aWhere += " = "+ UtilitaireCR.dateRequete(daty);
        } else if (nature == 2) {
            Date semaineDerniere = UtilitaireCR.dateSemaineDerniere(daty);
            aWhere += " > "+UtilitaireCR.dateRequete(semaineDerniere)+""+aWhere+" <= "+UtilitaireCR.dateRequete(daty);
        } else {
            Date moisDernier = UtilitaireCR.dateMoisDernier(daty);
            aWhere += " > "+UtilitaireCR.dateRequete(moisDernier)+""+aWhere+" <= "+UtilitaireCR.dateRequete(daty);
        }
        return aWhere;
    }

    public String genererMailContent(int nature, Date daty, Connection c)throws Exception{

        if(c==null){
            c = new UtilDB().GetConn();
        }

        String aWhere = "";
        aWhere = this.genererAWhere(nature, daty);

        ClassMAPTable mapping = this.getMapping();
        ClassMAPTable[] mappings = (ClassMAPTable[]) CGenUtil.rechercher(mapping, null, null, c, aWhere);

        String contenus = "<div class=\"crcontent\">";
        contenus += "<h3>"+this.getTitre()+"</h3>";


        if(this.getParagraphe()!=null && !this.getParagraphe().equals("")) {
            contenus += "<p>" + this.getParagraphe() + "</p>";
        }

        if (this.getColSomme()!=null){
            contenus += UtilitaireCR.sommeTable(mappings, this.getColSomme());
        }

        String header = UtilitaireCR.tableHeader(this.getLibEntete());
        if(this.getLibEnteteAffiche()!=null && this.getLibEnteteAffiche().length!=0){
            header = UtilitaireCR.tableHeader(this.getLibEnteteAffiche());
        }

        contenus += header;

        contenus += UtilitaireCR.tableContent(mappings, this.getLibEntete());

        contenus += "</div>";
        contenus += "<br></br>";

        return contenus;
    }
}
