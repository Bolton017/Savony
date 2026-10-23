<%--
  Created by IntelliJ IDEA.
  User: Tsinjoniaina
  Date: 4/30/2025
  Time: 10:06 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="vente.Carton" %>
<%@ page import="affichage.PageRecherche" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="static java.time.temporal.TemporalAdjusters.previousOrSame" %>
<%@ page import="static java.time.DayOfWeek.MONDAY" %>
<%@ page import="static java.time.temporal.TemporalAdjusters.nextOrSame" %>
<%@ page import="static java.time.DayOfWeek.SUNDAY" %>
<%@ page import="java.sql.Date" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%  try{

    LocalDate today = LocalDate.now();
    LocalDate monday = today.with(previousOrSame(MONDAY));
    LocalDate sunday = today.with(nextOrSame(SUNDAY));

    Carton carton = new Carton();
    String listCrt[] = {"id", "idBC", "dateCreation", "remarque"};
    String listInt[] = {"dateCreation"};
    String libEntete[] = {"id", "idBC", "dateCreation", "remarque"};

    PageRecherche pr = new PageRecherche(carton, request, listCrt, listInt, 3,libEntete, libEntete.length);
    pr.setTitre("Liste des Cartons");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("vente/miseenforme/carton-liste.jsp");
    pr.getFormu().getChamp("dateCreation1").setLibelle("Date min");
    pr.getFormu().getChamp("dateCreation1").setDefaut(utilitaire.Utilitaire.datetostring(Date.valueOf(monday)));
    pr.getFormu().getChamp("dateCreation2").setLibelle("Date max");
    pr.getFormu().getChamp("dateCreation2").setDefaut(utilitaire.Utilitaire.datetostring(Date.valueOf(sunday)));
    pr.getFormu().getChamp("dateCreation2").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("idBC").setLibelle("Id Bon de commande");

    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    Map<String,String> lienTab=new HashMap();
    lienTab.put("modifier",pr.getLien() + "?but=vente/miseencarton/carton-modif.jsp");
    pr.getTableau().setLienClicDroite(lienTab);

    String lienTableau[] = {pr.getLien() + "?but=vente/miseencarton/carton-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);

    String[] attributLien = {"id"};
    pr.getTableau().setAttLien(attributLien);

    String libEnteteAffiche[] = {"id", "Bon de commande", "Cr&eacute;ation", "remarque"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getTableau().setLienFille("vente/miseencarton/inc/carton-details.jsp&id=");

    pr.getTableau().setNameBoutton("Livrer");
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
            out.println(pr.getTableauRecap().getHtml());
        %>
        <form method="post" action="<%=(String) session.getValue("lien") + "?but=apresCarton.jsp" %>" >


            <%
                out.println(pr.getTableau().getHtmlWithCheckbox());
            %>
<%--            <input  type="hidden" name="acte" value="">--%>
<%--            <input  type="hidden" name="bute" value="bondelivraison-client/bondelivraison-client-saisie.jsp"  >--%>
<%--            <input  type="hidden" name="classe" value=""  >--%>
        </form>

        <br>
        <%
//            out.println(pr.getTableau().getHtmlWithCheckbox());
            out.println(pr.getBasPage());
        %>
    </section>
</div>
<%
    }catch(Exception e){
        e.printStackTrace();
    }
%>
