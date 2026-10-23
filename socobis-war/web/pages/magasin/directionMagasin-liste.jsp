<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="magasin.DirectionMagasinLib" %>
<%@ page import="affichage.Liste"%>
<%@ page import="magasin.Magasin" %>
<%@ page import="bean.TypeObjet" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>

<% try{ 
    DirectionMagasinLib o = new DirectionMagasinLib();
    o.setNomTable("DIRECTIONMAGASINLIB");
    String[] listeCrt = {"id","idMagasin","idDirection"};
    String[] listeInt = {};
    String[] libEntete = {"id","idMagasinLib","idDirectionLib"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("magasin/directionMagasin-liste.jsp");
    
    Liste[] liste = new Liste[2];
    Magasin liste0 = new Magasin();
    liste0.setNomTable("MAGASIN2");
    liste[0] = new Liste("idMagasin",liste0,"val","id");
    TypeObjet liste1 = new TypeObjet();
    liste1.setNomTable("DEPARTEMENT");
    liste[1] = new Liste("idDirection",liste1,"val","id");
    pr.getFormu().changerEnChamp(liste);
    pr.getFormu().getChamp("id").setLibelle("Id");
    pr.getFormu().getChamp("idMagasin").setLibelle("Magasin");
    pr.getFormu().getChamp("idDirection").setLibelle("D&eacute;paretment");
    
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] lienTableau = {pr.getLien() + "?but=magasin/directionMagasin-fiche.jsp"};
    String[] colonneLien = {"id"};
    String[] attributLien = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(attributLien);

    Map<String,String> lienTab=new HashMap<>();
    lienTab.put("modifier",pr.getLien() + "?but=magasin/directionMagasin-saisie.jsp&acte=update");
    lienTab.put("dupliquer",pr.getLien() + "?but=magasin/directionMagasin-saisie.jsp&acte=dupliquer");
//    lienTab.put("Rendre indisponible",pr.getLien() + "?but=rdv/rdv-saisie.jsp");
//    lienTab.put("Rendre disponible",pr.getLien() + "?but=rdv/rdv-saisie.jsp");
    pr.getTableau().setLienClicDroite(lienTab);

    String[] libEnteteAffiche = {"Id", "Magasin","D&eacute;paretment"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);

    pr.getFormu().setAnotherButton("" +
            "<a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=magasin/directionMagasin-saisie.jsp&currentMenu=MNDMDF0001\">\n" +
            "                    <i class=\"material-symbols-rounded\">add</i>Saisie d'une direction magasin</a>");
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

