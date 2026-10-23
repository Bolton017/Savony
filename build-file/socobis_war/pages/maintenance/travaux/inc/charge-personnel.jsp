<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="fabrication.*" %>

<%
    /*Fabrication fab = new Fabrication();
    fab.setId(request.getParameter("id"));
    RessourceParFabrication[] rf = fab.getRessourceFabrication(null);
    HeureSupFabricationCPL[] rep = new HeureSupFabricationCPL[rf.length];
    System.out.println("REF ************* : "+rf.length);
    for(int i=0;i<rf.length;i++){
        HeureSupFabricationCPL val=(HeureSupFabricationCPL) rf[i].getHeureSupFabrication(null);
        rep[i] = val;
    }*/
    HeureSupFabricationCPL r = new HeureSupFabricationCPL();
    r.setNomTable("HEURESUPFABRICATION_CPL");
    String listeCrt[] = {};
    String listeInt[] = {};
    String libEntete[] =  {"id","matricule", "tauxHoraire","tauxHoraireEffective","montantHeureNormale","montantHS", "montantMN", "montantJF", "montantHD","montantIF","montantTotalHS"};
    PageRecherche pr = new PageRecherche(r, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));

    if(request.getParameter("id") != null){
        pr.setAWhere(" and idFabrication='"+request.getParameter("id")+"'");
    }

    String[] colSomme = null;
    pr.setNpp(500);
    pr.creerObjetPage(libEntete, colSomme);
    //pr.getTableau().setData((bean.ClassMAPTable[]) rep);
    pr.getTableau().transformerDataString();

%>

<div class="box-body">
    <%
        String lienTableau[] = {pr.getLien() + "?but=fabrication/heureSup-fiche.jsp"};
        String colonneLien[] = {"id"};
        String[] attributLien = {"id"};
        String colonneModal[] = {"id"};
        pr.getTableau().setAttLien(attributLien);
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
        pr.getTableau().setAttLien(attributLien);
        pr.getTableau().setModalOnClick(true,colonneModal);
        String libEnteteAffiche[] =  {"id","matricule","Taux horaire","Taux horaire effective","Montant Heure Normale","Montant HS", "Montant MN", "Montant JF", "Montant HD","Montant IF","Montant Total"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        HeureSupFabricationCPL[] liste=(HeureSupFabricationCPL[]) pr.getTableau().getData();
        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
    %>
    <div class="w-100" style="display: flex; flex-direction: row-reverse;">
        <table style="width: 20%"class="table">
            <tr>
                <td><b>Total montant: </b></td>
                <td><b><%=utilitaire.Utilitaire.formaterAr(AdminGen.calculSommeDouble(liste,"montantTotalHS")) %></b></td>
            </tr>
        </table>
    </div>
    <%
    }
    else
    {
    %><center><h4>Aucune donn�e trouv�</h4></center><%
    }
%>

</div>
<%=pr.getModalHtml("modalContent")%>
