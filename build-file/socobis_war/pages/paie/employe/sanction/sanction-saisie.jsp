
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@page import="affichage.*"%>
<%@page import="bean.CGenUtil"%>
<%@page import="bean.TypeObjet"%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="user.UserEJB"%>
<%@ page import="affichage.Champ" %>
<%@ page import="paie.employe.sanction.Sanction"%>
<%
    try {
         Sanction a = new Sanction();
         a.setNomTable("SANCTION");
         String titre="Saisie d'une sanction";
         if (request.getParameter("acte") != null && request.getParameter("acte").equalsIgnoreCase("update"))
        {
            titre = "Modification de la Sanction ";
        }
         PageInsert pi = new PageInsert(a, request, (user.UserEJB) session.getValue("u"));
         pi.setLien((String) session.getValue("lien"));

        pi.getFormu().getChamp("idpersonne").setPageAppelComplete("paie.log.LogPersonnel","id","log_personnel_v2");
        pi.getFormu().getChamp("idpersonne").setLibelle("Personnel");

        Liste[] liste = new Liste[2];
        TypeObjet typeFaute = new TypeObjet();
        typeFaute.setNomTable("TYPEFAUTE");
        liste[0] = new Liste("typeFaute",typeFaute,"val","id");
        TypeObjet typeSanction = new TypeObjet();
        typeSanction.setNomTable("TYPESANCTION");
        liste[1] = new Liste("typeSanction", typeSanction, "val", "id");
        pi.getFormu().changerEnChamp(liste);
        if (request.getParameter("acte") != null && request.getParameter("acte").equalsIgnoreCase("update")) {
            pi.getFormu().getChamp("id").setVisible(false);
        }

        pi.getFormu().getChamp("typeFaute").setLibelle("Type de faute");
        pi.getFormu().getChamp("daty").setLibelle("Date");
        pi.getFormu().getChamp("typeSanction").setLibelle("Sanction appliquée");

        pi.getFormu().getChamp("descriptionFaute").setLibelle("Description de la faute");
        pi.getFormu().getChamp("idRegleEnfreinte").setPageAppelComplete("paie.employe.sanction.RegleInterieur","id","REGLEMENTINTERIEUR");
        pi.getFormu().getChamp("idRegleEnfreinte").setLibelle("R&egrave;gle enfreinte");

        pi.getFormu().getChamp("dateDebut").setLibelle("Date de d&eacute;but");
        pi.getFormu().getChamp("duree").setLibelle("Dur&eacute;e");
        pi.getFormu().getChamp("niveauSanction").setLibelle("Niveau de la sanction");
        pi.getFormu().getChamp("etat").setVisible(false);
         String classe = "paie.employe.sanction.Sanction";

         String butApresPost = "paie/employe/sanction/sanction-fiche.jsp";
         String nomTable = "SANCTION";
         pi.preparerDataFormu();
         pi.getFormu().makeHtmlInsertTabIndex();
     %>
     <div class="content-wrapper">
         <h1 align="center"><%=titre %></h1>
         <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post"  data-parsley-validate>
             <%
                 out.println(pi.getFormu().getHtmlInsert());
             %>
             <input name="acte" type="hidden" id="nature" value="insert">
             <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
             <input name="classe" type="hidden" id="classe" value="<%= classe %>">
             <input name="nomtable" type="hidden" id="nomtable" value="<%= nomTable %>">
         </form>
     </div>
     <%
     }catch (Exception e) {
         e.printStackTrace();
 } %>
