<%@ page import="affichage.*" %>
<%@ page import="maintenance.travaux.OrdreTravaux" %>


<%
    try{
        OrdreTravaux t = new OrdreTravaux();
        t.setNomTable("OTRAVLIB");
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"id", "daty", "besoin", "libelle", "lancepar", "remarque"};
        String libEnteteAffiche[] = {"ID", "Date","Date de besoin","D&eacute;signation","Entit&eacute;", "Remarque"};

        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        if(request.getParameter("id") != null){
            pr.setAWhere(" and idBc='"+request.getParameter("id")+"'");
        }
        String[] colSomme = null;
        //pr.setNpp(10);
        pr.creerObjetPage(libEntete, colSomme);
        pr.getTableau().transformerDataString();
%>

<div class="box-body">
    <%
        String lienTableau[] = {pr.getLien() + "?but=maintenance/travaux/Otravaux-fiche.jsp"};
        String colonneLien[] = {"id"}; // Colonne contenant un lien, passé comme paramètre dans l'URL
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
        //Remplacer le nom de l'attribut passé dans l'URL, par exemple passer 'idObjet' au lieu de 'id' du colonneLien
        String[] attributLien = {"id"};
        pr.getTableau().setAttLien(attributLien);
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        pr.getTableau().setLienFille("maintenance/travaux/inc/ordre-fabrication-details.jsp&id=");
        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
    %>
    <%  }if(pr.getTableau().getHtml() == null)
    {
    %><center><h4>Aucune donne trouvee</h4></center><%
    }


%>
</div>
<%=pr.getModalHtml("modalContent")%>
<%
    } catch (Exception e) {
        e.printStackTrace();
    }%>

