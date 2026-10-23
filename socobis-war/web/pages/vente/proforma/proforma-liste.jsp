<%--
  Created by IntelliJ IDEA.
  User: safidy
  Date: 05/08/2025
  Time: 14:02
  To change this template use File | Settings | File Templates.
--%>

<%@ page import="proforma.*" %>
<%@ page import="affichage.PageRecherche" %>
<%@page import="affichage.*"%>
<%@ page import="java.time.LocalDate" %>
<%@ page import="static java.time.temporal.TemporalAdjusters.previousOrSame" %>
<%@ page import="static java.time.DayOfWeek.MONDAY" %>
<%@ page import="static java.time.temporal.TemporalAdjusters.nextOrSame" %>
<%@ page import="static java.time.DayOfWeek.SUNDAY" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="utilitaire.Utilitaire" %>
<%  try{

    LocalDate today = LocalDate.now();
    LocalDate monday = today.with(previousOrSame(MONDAY));
    LocalDate sunday = today.with(nextOrSame(SUNDAY));

    ProformaLib dmd = new ProformaLib();
//    if (request.getParameter("etat") != null && request.getParameter("etat").compareToIgnoreCase("") != 0) {
//        dmd.setNomTable(request.getParameter("etat"));
//    }
    dmd.setNomTable("PROFORMA_CPL");
    String[] listCrt = {
            "id",
            "idMagasin",
            "daty",
            "dateValidite",
            "montantttc",
            "montantTva",
            "montanttotal",
            "idclientlib",
            "montantTtcAr"
    };
    String listInt[] = {"daty" , "dateValidite","montantTtcAr","montantttc","montantTva","montanttotal"};
    String libEntete[] = {"id", "daty", "dateValidite" ,"idclientLib","idMagasinLib","idDevise","montantttc","montantTtcAr","montantTva", "montanttotal","etatlib","etatbc"};

    PageRecherche pr = new PageRecherche(dmd, request, listCrt, listInt, 3,libEntete, libEntete.length);

    String etat = request.getParameter("etat") ;

    if ("1".equals(etat) || "11".equals(etat)) {
        pr.setAWhere(" AND etat = '" + etat + "'");
    }

    pr.setTitre("Liste des proformas");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("vente/proforma/proforma-liste.jsp");
    Liste[] liste = new Liste[1];
    liste[0] = new Liste("idMagasin",new magasin.Magasin(),"val","id");
    pr.getFormu().changerEnChamp(liste);

    pr.getFormu().getChamp("montantTtcAr1").setLibelle("Montant TTC min");
    pr.getFormu().getChamp("montantTtcAr2").setLibelle("Montant TTC max");
    pr.getFormu().getChamp("montantttc1").setLibelle("Montant TTC min");
    pr.getFormu().getChamp("montantttc2").setLibelle("Montant TTC max");
    pr.getFormu().getChamp("montantTva1").setLibelle("Montant TVA min");
    pr.getFormu().getChamp("montantTva2").setLibelle("Montant TVA max");
    pr.getFormu().getChamp("id").setLibelle("Ref.");
    //pr.getFormu().getChamp("montantPaye1").setLibelle("Montant Pay&eacute; min");
    //pr.getFormu().getChamp("montantPaye2").setLibelle("Montant Pay&eacute; max");
    pr.getFormu().getChamp("montanttotal1").setLibelle("Montant (HT) min");
    pr.getFormu().getChamp("montanttotal2").setLibelle("Montant (HT) max");

    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty1").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());


    pr.getFormu().getChamp("datevalidite1").setLibelle("Date de validit&eacute; min");
//    pr.getFormu().getChamp("datevalidite1").setDefaut(utilitaire.Utilitaire.dateDuJour());

    pr.getFormu().getChamp("datevalidite2").setLibelle("Date de validit&eacute; max");
//    pr.getFormu().getChamp("datevalidite2").setDefaut(utilitaire.Utilitaire.dateDuJour());


    pr.getFormu().getChamp("idMagasin").setLibelle("Magasin");
    pr.getFormu().getChamp("idClientLib").setLibelle("Client");

    String[] colSomme = {  "montanttotal", "montanttva","montantttcAr" };
    String[] enteteRecap = {"","Nombre de proforma","Somme du montant HT(AR)","Somme du montant TVA(AR)","Somme du montant TTC (AR)"};

    pr.creerObjetPage(libEntete, colSomme);

    String lienTableau[] = {pr.getLien() + "?but=vente/proforma/proforma-fiche.jsp"};
    String colonneLien[] = {"id"};
    Map<String,String> lienTab=new HashMap();
    String classe = "proforma.Proforma";
    String[] id = {"daty1","datevalidite1"};
    String[] val = {pr.getFormu().getChamp("daty1").getValeur(), pr.getFormu().getChamp("dateValidite1").getValeur()};
    lienTab.put("viser",pr.getLien() + "?but=apresTarif.jsp&acte=valider&bute=vente/proforma/proforma-liste.jsp&classe=" + classe+"&rajoutLien="+ Utilitaire.ajouterParam(id, val) );
    lienTab.put("dupliquer",pr.getLien() + "?but=vente/proforma/proforma-saisie.jsp&acte=dupliquer");
    pr.getTableau().setLienClicDroite(lienTab);
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableauRecap().setLibeEntete(enteteRecap);
    String[] attributLien = {"id"};
    pr.getTableau().setAttLien(attributLien);
    pr.getFormu().setAnotherButton(
            "                <a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=vente/proforma/proforma-saisie.jsp&currentMenu=MNDNAN001\">\n" +
            "                    <i class=\"material-symbols-rounded\">add</i>Saisir une proforma" +
            "                </a>"
    );


    String libEnteteAffiche[] = {"Ref.", "date", "Date d'expiration" ,"Client","Magasin","Devise","montant TTC",  "montant TTC ( AR)","montant TVA (AR)","montant HT (AR)", "&Eacute;tat" , "&Eacute;tat du bon de commande"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getTableau().setLienFille("vente/proforma/inc/proforma-detail-liste.jsp&id=");


%>

<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post"  name="liste" id="liste">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
             <div class="row col-md-12">
                <div class="col-md-4">
                    <label class="input-label" for="etat">&Eacute;tat :</label>
                    <select name="etat" class="champ form-control" id="etat" onchange="changerDesignation()">
                        <option value="%" <%= "%".equals(request.getParameter("etat")) || request.getParameter("etat") == null ? "selected" : "" %>>
                            Tous
                        </option>
                        <option value="1" <%= "1".equals(request.getParameter("etat")) ? "selected" : "" %>>
                            Cr&eacute;&eacute;(s)
                        </option>
                        <option value="11" <%= "11".equals(request.getParameter("etat")) ? "selected" : "" %>>
                            Vis&eacute;(s)
                        </option>

                    </select>
                </div>
            </div>
        </form>
         <br>
        <%
            out.println(pr.getTableauRecap().getHtml());
        %>
            <%
                out.println(pr.getTableau().getHtml());
            %>

        <br>
        <%
            out.println(pr.getBasPage());
        %>
    </section>
</div>
<script>
    function changerDesignation() {
        document.getElementById("liste").submit();
    }
</script>
<%
    }catch(Exception e){
        e.printStackTrace();
    }
%>


