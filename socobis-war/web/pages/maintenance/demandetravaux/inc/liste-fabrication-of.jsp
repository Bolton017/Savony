<%@ page import="affichage.*" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="maintenance.travaux.TravauxCpl" %>


<%
    try{
        TravauxCpl t = new TravauxCpl();
        t.setNomTable("TravauxCpl");
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"id","libelle","lanceparLib","remarque","daty","etatlib"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        if(request.getParameter("id") != null){
            pr.setAWhere(" and IDOFFILLE='"+request.getParameter("id")+"'");
        }

        String[] colSomme = null;
        pr.creerObjetPage(libEntete, colSomme);

        Map<String,String> lienTab=new HashMap();
        lienTab.put("Valider",pr.getLien() + "?but=apresTarif.jsp&acte=valider&bute=maintenance/travaux/Travaux-fiche.jsp&classe=maintenance.travaux.Travaux&nomtable=Travaux");
        pr.getTableau().setLienClicDroite(lienTab);

        pr.getTableau().transformerDataString();
        String lienTableau[] = {pr.getLien() + "?but=maintenance/travaux/Travaux-fiche.jsp"};
        String colonneLien[] = {"id"};
        String colonneModal[] = {"id"};

        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
        pr.getTableau().setLienFille("maintenance/travaux/inc/fabrication-details.jsp&id=");
        pr.getTableau().setModalOnClick(true,colonneModal);
%>

<div class="box-body">
    <%
        String libEnteteAffiche[] =  {"id","D&eacute;signation","Lanc&eacute;e par","Remarque","Date","&Eacute;tat"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
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

