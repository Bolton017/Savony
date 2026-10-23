<%@page import="vente.VenteLib"%>
<%@page import="vente.Vente"%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="java.time.LocalDate" %>
<%@ page import="static java.time.DayOfWeek.MONDAY" %>
<%@ page import="static java.time.temporal.TemporalAdjusters.previousOrSame" %>
<%@ page import="static java.time.DayOfWeek.SUNDAY" %>
<%@ page import="static java.time.temporal.TemporalAdjusters.nextOrSame" %>
<%@ page import="java.sql.Date" %>
<%@ page import="java.util.Map" %> 
<%@ page import="java.util.HashMap" %>
<%@ page import="vente.Vente" %>
<%@page import="affichage.PageRechercheChoix"%>

<%
    try{
    String champReturn = request.getParameter("champReturn");
    VenteLib bc = new VenteLib();
    String[] etatVal = {"","1","11", "0"};
    String[] etatAff = {"Tous","Cr&eacute;e(s)", "Vis&eacute;e(s)", "Annul&eacute;e"};
    bc.setNomTable("VENTE_CPL");

    LocalDate today = LocalDate.now();
    LocalDate monday = today.with(previousOrSame(MONDAY));
    LocalDate sunday = today.with(nextOrSame(SUNDAY));

    if (request.getParameter("devise") != null && request.getParameter("devise").compareToIgnoreCase("") != 0) {
        bc.setNomTable(request.getParameter("devise"));
    } else {
        bc.setNomTable("VENTE_CPL");
    }
      String[] listeCrt = {"id", "designation","idClientLib","referencefacture","daty","datyprevu","montantttc","montantRevient","margeBrute","montantpaye","montantreste"};
    String[] listeInt = {"daty","datyprevu","montantttc","montantRevient","margeBrute","montantpaye","montantreste"};
    String[] libEntete = {"id", "designation","idClientLib","idDevise","referencefacture","daty","montantttc","montantRevient","margeBrute","montantpaye", "montantreste","etatlib","datyprevu"};
    String[] libEnteteAffiche = {"id", "D&eacute;signation","Client","devise","R&eacute;f&eacute;rence facture","Date","Montant TTC","Montant de revient","marge Brute","Montant Pay&eacute;","Montant restant","&Eacute;tat","&Eacute;ch&eacute;ance"};
    int range = 2;
    PageRechercheChoix pr = new PageRechercheChoix(bc, request, listeCrt, listeInt, range, libEntete, libEntete.length);
    String awhere = "";
    if(request.getParameter("etat")!=null && request.getParameter("etat").compareToIgnoreCase("")!=0) {
        awhere += " and etat>=" + request.getParameter("etat");
    }
    if(request.getParameter("paiement")!=null && request.getParameter("paiement").compareToIgnoreCase("")!=0) {
        if(request.getParameter("paiement").compareToIgnoreCase("payer")==0){
            awhere +=" and montantreste = 0";
        }else if(request.getParameter("paiement").compareToIgnoreCase("nonpayer")==0){
            awhere +=" and montantreste > 0";
        }else if(request.getParameter("paiement").compareToIgnoreCase("avoir")==0){
            awhere +=" and montantreste < 0";
        }
    }
    pr.setAWhere(awhere);
    pr.setTitre("Choix facture vente ");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("vente-choix.jsp");
    pr.setChampReturn(champReturn);
    String[] colSomme = { "montantttc", "montantpaye", "montantreste","margeBrute" };
    pr.getFormu().getChamp("id").setLibelle("ID");
    pr.getFormu().getChamp("idClientLib").setLibelle("Client");
    pr.getFormu().getChamp("daty1").setLibelle("Date Min");
    pr.getFormu().getChamp("datyPrevu1").setLibelle("Date Pr&eacute;visionnelle Min");
    pr.getFormu().getChamp("datyPrevu2").setLibelle("Date Pr&eacute;visionnelle Max");
    //pr.getFormu().getChamp("avecCommission").setLibelle("Avec commission");
   //pr.getFormu().getChamp("daty1").setDefaut(utilitaire.Utilitaire.datetostring(Date.valueOf(monday)));
    pr.getFormu().getChamp("daty2").setLibelle("Date Max");
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.datetostring(Date.valueOf(sunday)));
    pr.creerObjetPage(libEntete, colSomme);
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());



    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=vente/vente-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
%>

<html>
<head>
    <meta charset="UTF-8">
    <title><%= pr.getTitre()%></title>
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
    <jsp:include page='./../../elements/css.jsp'/>
</head>
<body class="skin-blue sidebar-mini">
<div class="wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre()%></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getApres()%>?champReturn=<%=champReturn%>" method="post" name="fcdetailsliste" id="fcdetailsliste">
            <% out.println(pr.getFormu().getHtmlEnsemble());%>
        </form>
        <form action="./../apresChoix.jsp" method="post" name="frmchx" id="frmchx">
            <input type="hidden" name="champReturn" value="<%=pr.getChampReturn()%>">
            <%  out.println(pr.getTableau().getHtmlWithRadioButton()); %>
        </form>
        <% out.println(pr.getBasPage());%>
    </section>
</div>
<jsp:include page='./../../elements/js.jsp'/>
</body>
</html>
<%
} catch (Exception e) {
    e.printStackTrace();
}
%>