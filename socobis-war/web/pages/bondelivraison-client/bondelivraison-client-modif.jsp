<%@page import="annexe.Unite"%>
<%@page import="magasin.Magasin"%>
<%@page import="vente.*"%>
<%@page import="bean.CGenUtil"%>
<%@page import="affichage.PageUpdateMultiple"%>
<%@page import="faturefournisseur.*"%>
<%@page import="bean.UnionIntraTable"%>
<%@page import="user.UserEJB"%>
<%@page import="affichage.PageInsertMultiple"%>
<%@page import="java.util.Calendar"%>
<%@page import="affichage.Liste"%>
<%@page import="bean.TypeObjet"%>
<%@page import="affichage.PageInsert"%>
<%@page import="utilitaire.Utilitaire"%>
<%    
    try{
    String autreparsley = "data-parsley-range='[8, 40]' required";
    UserEJB u = null;
    String idUser= "";
    String idbc = request.getParameter("id");
    u = (UserEJB) session.getValue("u");
    idUser = ""+u.getUser().getTuppleID();
    As_BondeLivraisonClient mere = new As_BondeLivraisonClient();
    As_BondeLivraisonClientFilleInsertion fille = new As_BondeLivraisonClientFilleInsertion();
    fille.setNomTable("As_BLClientFilleInsertion");
    fille.setNumbl(request.getParameter("id"));
    As_BondeLivraisonClientFille[] listef = (As_BondeLivraisonClientFille[])CGenUtil.rechercher(fille, null, null, "");
    PageUpdateMultiple pi = new PageUpdateMultiple(mere, fille, listef, request, u, 2);
     pi.setLien((String) session.getValue("lien"));
    pi.getFormu().getChamp("idbc").setAutre("readonly");
    pi.getFormu().getChamp("remarque").setLibelle("Remarque");
    pi.getFormu().getChamp("daty").setLibelle("Date");
    pi.getFormu().getChamp("idVente").setLibelle("R&eacute;f&eacute;rence Vente");
    pi.getFormu().getChamp("idbc").setLibelle("R&eacute;f&eacute;rence Bon de commande");
    pi.getFormu().getChamp("idVente").setAutre("readonly");
    pi.getFormu().getChamp("etat").setVisible(false);
    pi.getFormu().getChamp("idClient").setVisible(false);
    pi.getFormu().getChamp("idOrigine").setVisible(false);
    affichage.Liste[] liste = new Liste[1];
    Magasin mg = new Magasin();
    liste[0] = new Liste("magasin",mg,"val","id");
    pi.getFormu().changerEnChamp(liste);
    affichage.Liste[] listed = new affichage.Liste[pi.getNombreLigne()];
    for (int i = 0; i < pi.getNombreLigne(); i++) {

        pi.getFormufle().getChamp("id_"+i).setAutre("readonly");
        pi.getFormufle().getChamp("uniteLib_"+i).setAutre("readonly");
        pi.getFormufle().getChamp("produitLib_0").setLibelle("Produit");
        affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("produitlib"),"annexe.ProduitLib","id","PRODUIT_LIB","id;idUniteLib;idUnite","produit;unitelib;unite");

        pi.getFormufle().getChamp("unitelib_0").setLibelle("Unit&eacute;");
        pi.getFormufle().getChamp("quantite_0").setLibelle("Quantit&eacute;");
//        pi.getFormufle().getChamp("idventedetail_0").setLibelle("Vente");
    } 

    
    
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("id"),false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("numbl"),false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("produit"),false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("unite"),false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("idbc_fille"),false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("idventedetail"),false);   

    mere = (As_BondeLivraisonClient) pi.getBase();
    String[] order_form = {"daty","remarque","idVente","idbc","magasin","idclient","idorigine","etat"};
    pi.getFormu().setOrdre(order_form);
    pi.preparerDataFormu();

    
%>
<div class="content-wrapper">
    <h1 class="box-title"> <a href="<%=pi.getLien()%>?but=bondelivraison-client/bondelivraisonclient-liste.jsp"><i class='fa fa-angle-left'></i></a>Modification du Bon de livraison client</h1>
     
    <form action="<%=pi.getLien()%>?but=apresMultiple.jsp&id=<%out.print(request.getParameter("id"));%>" method="post" name="sortie" id="sortie" data-parsley-validate>
        <%
            pi.getFormu().makeHtmlInsertTabIndex();
            pi.getFormufle().makeHtmlInsertTableauIndex();
            out.println(pi.getFormu().getHtmlInsert());
        %>
                <div class="row m-0">
                    <div class="col-md-12 nopadding">
                        <%
                            out.println(pi.getFormufle().getHtmlTableauInsert());
                        %>
                    </div>
                </div>
        <input name="acte" type="hidden" id="acte" value="updateInsert">
        <input name="bute" type="hidden" id="bute" value="bondelivraison-client/bondelivraison-client-fiche.jsp?id=<%=request.getParameter("id")%>">
        <input name="classe" type="hidden" id="classe" value="vente.As_BondeLivraisonClient">
        <input name="classefille" type="hidden" id="classefille" value="vente.As_BondeLivraisonClientFille">
        <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%=pi.getNombreLigne()%>">
        <input name="colonneMere" type="hidden" id="colonneMere" value="numbl">
    </form>
</div>
<script>
    function add_line() {
        var indexMultiple = document.getElementById('indexMultiple').value;
        var nbrLigne = document.getElementById('nbrLigne').value;

        var html = "<tr id='ligne-multiple-"+nbrLigne+"'><td align=center><input type='checkbox' value='"+nbrLigne+"' name='id' id='checkbox"+nbrLigne+"'/></td>";
        html += "<input name='id_"+nbrLigne+"' type='hidden' class='form-control' id='id_"+nbrLigne+"' value>";
        html+="<td style='display: flex;'><input name=id1libelle_"+nbrLigne+" type=textbox class='form-control' id=id1libelle_"+nbrLigne+" value readonly=><input type=hidden value name=id1_"+nbrLigne+" id=id1_"+nbrLigne+"><input name=choix type=button class=submit onclick=pagePopUp('choix/idvaldesceChoix.jsp?champReturn=id1_"+nbrLigne+";id1libelle_"+nbrLigne+"&amp;nomTable=composante&amp;ik=_"+nbrLigne+"&amp;apresLienPageAppel=') value=...></td>";
        html+="<input name='id2_"+nbrLigne+"' type='hidden' class='form-control' id='id2_"+nbrLigne+"' value>"
        html +="<td><a href='#'><span class='glyphicon glyphicon-remove'></span></a></td></tr>";
        
        $('#ajout_multiple_ligne').append(html);
        document.getElementById('indexMultiple').value = parseInt(indexMultiple) + 1;
        document.getElementById('nbrLigne').value = parseInt(nbrLigne) + 1;
        document.getElementById('nombreLigne').value = parseInt(nbrLigne) + 1;
    }
</script>
<%
} catch (Exception e) {
    e.printStackTrace();
}%>
