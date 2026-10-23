<%@page import="vente.As_BondeLivraisonClient_Cpl"%>
<%@page import="vente.BonDeCommandeCpl"%>
<%@page import="affichage.PageRecherche"%>
<%@page import="magasin.Magasin"%>
<%@page import="affichage.Liste"%>
<%@page import="faturefournisseur.ModePaiement"%>
<%@ page import="java.util.Map" %> 
<%@ page import="java.util.HashMap" %>
<% try{ 
    As_BondeLivraisonClient_Cpl bdlc = new As_BondeLivraisonClient_Cpl();
    String nomTable = "AS_BONDELIVRAISONCLIENT_LIBCPL";
    bdlc.setNomTable(nomTable);
    bdlc.setIdbc(request.getParameter("id"));
    
    String listeCrt[] = {};
    String listeInt[] = {};
    String libEntete[] = {"id","daty","idclientlib","idmagasinlib","remarque","etatlib"};
    PageRecherche pr = new PageRecherche(bdlc, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des Bons de livraison client");
    pr.setAWhere(" and IDBC  ='"+request.getParameter("id")+"' ");

    // Changer en Liste
    // Initialisation Liste

    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("bondelivraison-client/bondelivraison-client-liste.jsp");
   
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    Map<String,String> lienTab=new HashMap();
    lienTab.put("modifier",pr.getLien() + "?but=bondelivraison-client/bondelivraison-client-modif.jsp"); 
    pr.getTableau().setLienClicDroite(lienTab);


    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=bondelivraison-client/bondelivraison-client-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setLienFille("bondelivraison-client/inc/bondelivraisonclient-liste-detail.jsp&id=");
    String libEnteteAffiche[] = {"Ref.","Date","Client","Magasin","Remarque","&Eacute;tat"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
%>
<script>
    function changerDesignation() {
        document.getElementById("bdlc-liste--form").submit();
    }
</script>
<div class="box-body">
    <%
        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
         %>
       <%
          } 
        else
            {
               %><center><h4>Aucune donn&eacute;e trouv&eacute;</h4></center><%
        }
    %>
            
</div>
    <%
    }catch(Exception e){

        e.printStackTrace();
    }
%>
