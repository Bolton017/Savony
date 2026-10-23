<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="paie.accident.TauxGravite" %>

<% try{ 
    TauxGravite o = new TauxGravite();
    o.setNomTable("V_TAUX_GRAVITE_ACCIDENT");
    String[] listeCrt = {"idaccident","idpersonnel","cause","nbjourpris","heuretotalperdue"};
    String[] listeInt = {};
    String[] libEntete = {"id","idaccident","idpersonnel","cause","nbjourpris","heuretotalenormale","heuretotalperdue","pourcentagegravite"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("taux-gravite-accident");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("paie/accident/taux-gravite-accident.jsp");
    pr.getFormu().getChamp("idaccident").setLibelle("Id Accident");
    pr.getFormu().getChamp("idpersonnel").setLibelle("Id Personnel");
    pr.getFormu().getChamp("nbjourpris").setLibelle("Nombre de jours pris");
    pr.getFormu().getChamp("heuretotalperdue").setLibelle("Heures totales perdues");

//    String[] lienTableau = {pr.getLien() + "?but=paie/accident/accident-fiche.jsp",pr.getLien() + "?but=paie/employe/personnel-fiche-portrait.jsp"};
//    String[] colonneLien = {"idaccident","idpersonnel"};
//    String[] attributLien = {"id","id"};
//    pr.getTableau().setLien(lienTableau);
//    pr.getTableau().setColonneLien(colonneLien);
//    pr.getTableau().setAttLien(attributLien);

    String[] colSomme = {"nbjourpris","heuretotalperdue"};
    pr.creerObjetPage(libEntete, colSomme);

    String[] enteteRecap = {"","Nombre","Nombre de jours pris","Heure totale perdue"};
    pr.getTableauRecap().setLibeEntete(enteteRecap);

    String[] libEnteteAffiche = {"Id","Id Accident","Id Personnel","Cause","Nombre de jours pris","Heure totale normale","Heure totale perdue","Pourcentage de gravit&eacute;"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
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
        <br>
        <%
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>

<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>

