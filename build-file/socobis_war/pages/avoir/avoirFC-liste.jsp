<%-- 
    Document   : avoirFC-liste
    Created on : 2 ao�t 2024, 15:48:25
    Author     : randr
--%>


<%@page import="avoir.AvoirFCLib"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="java.time.LocalDate" %>
<%@ page import="static java.time.DayOfWeek.MONDAY" %>
<%@ page import="static java.time.temporal.TemporalAdjusters.previousOrSame" %>
<%@ page import="static java.time.DayOfWeek.SUNDAY" %>
<%@ page import="static java.time.temporal.TemporalAdjusters.nextOrSame" %>
<%@ page import="java.sql.Date" %>
<%@ page import="affichage.Liste" %>
<%@ page import="bean.TypeObjet" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="utilitaire.Utilitaire" %>

<% try{
    LocalDate today = LocalDate.now();
    LocalDate monday = today.with(previousOrSame(MONDAY));
    LocalDate sunday = today.with(nextOrSame(SUNDAY));

    AvoirFCLib t = new AvoirFCLib();
    t.setNomTable("avoirfclib_cpl");
    String listeCrt[] = {"id","daty", "clientlib", "idMagasinLib", "idorigine", "typeavoir", "idMotifLib" , "idCategorieLib","idDevise", "montantTTC", "montantHTAr", "montantTVAAr", "montantTTCAr","numfact","montantHT"};
    String listeInt[] = {"daty","montantTTC", "montantHTAr", "montantTVAAr", "montantTTCAr","montantHT"};
    String libEntete[] = {"id", "daty","clientlib",  "idMagasinLib", "idorigine", "typeavoir", "idMotifLib" , "idCategorieLib","idDevise","montantTTC", "montantHTAr", "montantTVAAr", "montantTTCAr","etatLib"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des factures d'avoir");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("avoir/avoirFC-liste.jsp");
    pr.getFormu().getChamp("id").setLibelle("Id");

    pr.getFormu().getChamp("id").setLibelle("Ref.");

    pr.getFormu().getChamp("numfact").setLibelle("Num&eacute;ro de facture");

    pr.getFormu().getChamp("daty1").setLibelle("Date Min");
    pr.getFormu().getChamp("daty1").setDefaut(utilitaire.Utilitaire.datetostring(Date.valueOf(monday)));
    pr.getFormu().getChamp("daty2").setLibelle("Date Max");
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.datetostring(Date.valueOf(sunday)));
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());
    Liste[] liste = new Liste[5];
    liste[0] = new Liste("idMagasinLib",new magasin.Magasin(),"val","val");
    TypeObjet motif = new TypeObjet();
    motif.setNomTable("motifavoirfc");
    liste[1] = new Liste("idMotifLib",motif,"val","val");
    TypeObjet cat = new TypeObjet();
    cat.setNomTable("categorieavoirfc");
    liste[2] = new Liste("idCategorieLib",cat,"val","val");
    TypeObjet typeav = new TypeObjet();
    typeav.setNomTable("typeavoir");
    liste[3] = new Liste("typeavoir",typeav,"val","val");
    liste[4] = new Liste("idDevise",new caisse.Devise(),"val","id");

    pr.getFormu().changerEnChamp(liste);
    pr.getFormu().getChamp("idDevise").setLibelle("Devise");
    pr.getFormu().getChamp("idorigine").setLibelle("Ref. vente");
    pr.getFormu().getChamp("montantHT1").setLibelle("Montant HT Min");
    pr.getFormu().getChamp("montantHT2").setLibelle("Montant HT Max");
    pr.getFormu().getChamp("montantHTAr1").setLibelle("Montant HT Min (AR)");
    pr.getFormu().getChamp("montantHTAr2").setLibelle("Montant HT Max (AR)");
    pr.getFormu().getChamp("montantTTC1").setLibelle("Montant TTC Min");
    pr.getFormu().getChamp("montantTTC2").setLibelle("Montant TTC Max");
    pr.getFormu().getChamp("montantTVAAr1").setLibelle("Montant TVA Min");
    pr.getFormu().getChamp("montantTVAAr2").setLibelle("Montant TVA Max");
    pr.getFormu().getChamp("MontantTTCAr1").setLibelle("Montant TTC Min (AR)");
    pr.getFormu().getChamp("MontantTTCAr2").setLibelle("Montant TTC Max (AR)");


    pr.getFormu().getChamp("idMagasinLib").setLibelle("Magasin");
    //pr.getFormu().getChamp("idVenteLib").setLibelle("Vente");
    pr.getFormu().getChamp("idCategorieLib").setLibelle("Cat&eacute;gorie");
    pr.getFormu().getChamp("idMotifLib").setLibelle("Motif");
    pr.getFormu().getChamp("typeavoir").setLibelle("Type");
    pr.getFormu().getChamp("clientlib").setLibelle("Client");

    String[] colSomme = { "montantHTAr", "montantTVAAr", "montantTTCAr" };
    String[] labelRecap = { "","Nombres","Somme des montants HT (Ar)", "Somme des montants TVA (Ar)", "Somme des montants TTC (Ar)" };
    pr.creerObjetPage(libEntete, colSomme);
    Map<String,String> lienTab=new HashMap();
    String[] id = {"daty1"};
    String[] val = {pr.getFormu().getChamp("daty1").getValeur()};
    lienTab.put("Valider",pr.getLien() + "?&classe=avoir.AvoirFC&but=apresTarif.jsp&bute=avoir/avoirFC-liste.jsp&acte=valider"+"&rajoutLien="+ Utilitaire.ajouterParam(id, val) );
    lienTab.put("dupliquer",pr.getLien() + "?but=avoir/avoirFC-saisie.jsp&acte=dupliquer");
    pr.getTableau().setLienClicDroite(lienTab);
    pr.getTableauRecap().setLibeEntete(labelRecap);
    pr.getTableauRecap().setLibeEntete(labelRecap);
    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=avoir/avoirFC-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    String libEnteteAffiche[] = {"Ref.", "Date", "Client", "Magasin", "Ref. Vente", "Type", "Motif" , "Cat&eacute;gorie", "Devise", "montant TTC","montant HT (Ar)", "montant TVA (Ar)", "montant TTC (Ar)","&Eacute;tat"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getFormu().setAnotherButton(
            "                <a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=avoir/avoirFC-saisie.jsp&currentMenu=MNDN0001109002\">\n" +
                    "                    <i class=\"material-symbols-rounded\">add</i> Saisir un avoir client" +
                    "                </a>"
    );
%>

<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        </form>
        <%
            out.println(pr.getTableauRecap().getHtml());%>
        <br>
        <%
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>
<%
    }catch(Exception e){

        e.printStackTrace();
    }
%>