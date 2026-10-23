<%--
    Document   : classe-saisie.jsp
    Created on : 17 juin 2024, 15:32:16
    Author     : Mirado
--%>

<%@page import="annexe.Unite"%>
<%@page import="magasin.Magasin"%>
<%@page import="faturefournisseur.*"%>
<%@page import="user.*"%>
<%@page import="bean.*" %>
<%@page import="affichage.*"%>
<%@page import="utilitaire.*"%>

<%
  try{
    String idbc = request.getParameter("id");
    UserEJB u = null;
    u = (UserEJB) session.getValue("u");
    PageInsertMultiple pi=null;
    As_BonDeLivraison mere = new As_BonDeLivraison();
    As_BonDeLivraison_Fille_Cpl fille = new As_BonDeLivraison_Fille_Cpl();
    fille.setNomTable("As_BonDeLivraison_Fille_vide");
    int nombreLigne = 10;
    As_BonDeCommande_Fille_CPL_Livre[] detailsBC=null;
    FactureFournisseurDetailResteALivrerLib[] details=null;
    if(idbc!=null && idbc.startsWith("BC")){
      As_BonDeCommande_Fille_CPL_Livre bcfille=new As_BonDeCommande_Fille_CPL_Livre();
      bcfille.setNomTable("as_bondecommande_livre");
      detailsBC = (As_BonDeCommande_Fille_CPL_Livre[]) CGenUtil.rechercher(bcfille,null,null," and idbc='"+idbc+"' ");
      pi = new PageInsertMultiple(mere, fille, request,detailsBC.length, u);
    }else if(idbc!=null && idbc.startsWith("FCF")){
      details = (FactureFournisseurDetailResteALivrerLib[])CGenUtil.rechercher(new FactureFournisseurDetailResteALivrerLib(),null,null," and idFactureFournisseur='"+idbc+"' ");
      pi = new PageInsertMultiple(mere, fille, request,details.length, u);
    }else{
      pi = new PageInsertMultiple(mere,fille,request, nombreLigne,u);
    }



    pi.setLien((String) session.getValue("lien"));
    pi.getFormu().getChamp("idbc").setAutre("readonly");
    pi.getFormu().getChamp("idbc").setVisible(false);
    pi.getFormu().getChamp("idbc").setDefaut(idbc);
    pi.getFormu().getChamp("remarque").setLibelle("Remarques");
    pi.getFormu().getChamp("daty").setLibelle("Date");
    pi.getFormu().getChamp("idFactureFournisseur").setVisible(false);
    pi.getFormu().getChamp("idFournisseur").setLibelle("Fournisseur");
    pi.getFormu().getChamp("idFournisseur").setPageAppelComplete("faturefournisseur.Fournisseur","id","fournisseur");
    pi.getFormu().getChamp("etat").setVisible(false);
    affichage.Liste[] liste = new Liste[1];
    Magasin mg = new Magasin();
    liste[0] = new Liste("magasin",mg,"val","id");
    pi.getFormu().changerEnChamp(liste);
    if(details!=null){
      for (int idx = 0; idx < details.length; idx++) {
        pi.getFormufle().getChamp("produit_"+idx).setDefaut(details[idx].getProduit());
        pi.getFormufle().getChamp("produitlib_"+idx).setDefaut(details[idx].getProduitlib());
        pi.getFormufle().getChamp("unite_"+idx).setDefaut(""+details[idx].getUnite());
        pi.getFormufle().getChamp("quantite_"+idx).setDefaut(""+details[idx].getQte_reste());

        //pi.getFormufle().getChamp("iddetailsfacturefournisseur_"+idx).setDefaut(""+details[idx].getId());
        pi.getFormufle().getChamp("iddetailsfacturefournisseur_"+idx).setAutre("readonly");
        pi.getFormufle().getChamp("idbc_fille_"+idx).setDefaut(""+details[idx].getId());
        pi.getFormufle().getChamp("produitlib_"+idx).setAutre("onblur='changeUnite("+idx+")'");
      }
    }else if(detailsBC!=null){
      for (int idx = 0; idx < detailsBC.length; idx++) {
        pi.getFormufle().getChamp("produit_"+idx).setDefaut(detailsBC[idx].getProduit());
        pi.getFormufle().getChamp("produitlib_"+idx).setDefaut(detailsBC[idx].getProduitlib());
        pi.getFormufle().getChamp("produitlib_"+idx).setAutre("onblur='changeUnite("+idx+")'");
        pi.getFormufle().getChamp("unite_"+idx).setDefaut(""+detailsBC[idx].getUnite());
        pi.getFormufle().getChamp("quantite_"+idx).setDefaut(""+detailsBC[idx].getQte_reste());

        //pi.getFormufle().getChamp("iddetailsfacturefournisseur_"+idx).setDefaut(""+detailsBC[idx].getId());
        pi.getFormufle().getChamp("iddetailsfacturefournisseur_"+idx).setAutre("readonly");
        pi.getFormufle().getChamp("idbc_fille_"+idx).setDefaut(""+detailsBC[idx].getId());
      }
    }



    pi.getFormufle().getChamp("produitlib_0").setLibelle("Produit");
    pi.getFormufle().getChamp("unitelib_0").setLibelle("Unit&eacute;");
    pi.getFormufle().getChamp("pu_0").setLibelle("Prix Unitaire");
    pi.getFormufle().getChamp("quantite_0").setLibelle("Quantit&eacute;");
    pi.getFormufle().getChamp("iddetailsfacturefournisseur_0").setLibelle("facture fournisseur");
    
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("id"),false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("numbl"),false);
    affichage.Champ.setAutre(pi.getFormufle().getChampFille("unitelib"),"readonly");
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("produit"),false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("unite"),false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("idbc_fille"),false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("iddetailsfacturefournisseur"),false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("etat"),false);
    affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("produitlib"),"annexe.ProduitLib","id" , "Produit_LIB", "id;idUnite;idUniteLib", "produit;unite;unitelib");
    String[] order_form = {"daty","remarque","idFournisseur","magasin","idFactureFournisseur","idbc","etat"};
    pi.getFormu().setOrdre(order_form);
    
    String[] order = {"produitlib", "unitelib","quantite", "pu", "id", "numbl","idbc_fille","iddetailsfacturefournisseur","etat","produit","unite"};
    pi.getFormufle().setColOrdre(order);

    pi.preparerDataFormu();

    //Variables de navigation
    String classeMere = "faturefournisseur.As_BonDeLivraison";
    String classeFille = "faturefournisseur.As_BonDeLivraison_Fille";
    String butApresPost = "bondelivraison/bondelivraison-fiche.jsp";
    String colonneMere = "numbl";
    //Preparer les affichages
//
//    String[] colOrdre = {"produitlib_0","quantite_0","unitelib_0"};
//    pi.getFormufle().setColOrdre(colOrdre);
    pi.preparerDataFormu();

    pi.getFormu().makeHtmlInsertTabIndex();
    pi.getFormufle().makeHtmlInsertTableauIndex();
%>
<div class="content-wrapper">
  <!-- A modifier -->
  <h1>R&eacute;ception des produits</h1>
  <!--  -->
  <form class='container' action="<%=pi.getLien()%>?but=apresMultiple.jsp" method="post" >
    <%

      out.println(pi.getFormu().getHtmlInsert());
      out.println(pi.getFormufle().getHtmlTableauInsert());
    %>

    <input name="acte" type="hidden" id="nature" value="insert">
    <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
    <input name="classe" type="hidden" id="classe" value="<%= classeMere %>">
    <input name="classefille" type="hidden" id="classefille" value="<%= classeFille %>">
    <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%= nombreLigne %>">
    <input name="colonneMere" type="hidden" id="colonneMere" value="<%= colonneMere %>">
  </form>

</div>

<%
} catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript">
  alert('<%=e.getMessage()%>');
  history.back();
</script>
<% }%>
<script>
  window.addEventListener('load', function() {
    let firstLimit = 10;
    for (let i = 0; i < firstLimit; i++) {
      let currentId = 'produitlib_' + i + 'libelle';
      let input = document.getElementById(currentId);
      input.addEventListener('keydown', function(event) {
        if (event.key === 'Enter') {
          event.preventDefault();

          const currentInput = event.target;
          const currentId = currentInput.id;
          const nextId = currentId.replace(/\d+/, function(num) {
            return parseInt(num) + 1;
          });
          const nextInput = document.getElementById(nextId);
          const numMatch = currentId.match(/\d+/);
          let prevNum = -1;
          if (numMatch) {
            prevNum = parseInt(numMatch[0]);
          }

          $('#' + currentId).autocomplete({
            source: function(request, response) {
              $.ajax({
                url: "/savonnerie/autocomplete",
                method: "GET",
                contentType: "application/x-www-form-urlencoded",
                dataType: "json",
                data: {
                  libelle: request.term,
                  affiche: null,
                  valeur: 'id',
                  nomTable: 'Produit_LIB',
                  classe: 'annexe.ProduitLib',
                  champRetour: 'idUnite;idUniteLib',
                  colFiltre: 'id',
                  useMotcle: true
                },
                success: function(data) {
                  console.log(data);
                  response($.map(data.valeure, function(item) {
                    return {
                      label: item.id,
                      value: item.valeur,
                      retour: item.retour
                    };
                  }));
                }
              });
            },

            response: function(event, ui) {
              let item = ui.content[0];

              // Vérifier si le produit est déjà dans une autre ligne
              for (let j = 0; j < firstLimit; j++) {
                if (j === prevNum) continue;
                let idExist = $('#produit_' + j).val();
                if (idExist === item.label) {
                  // Produit déjà existant → incrémenter quantité
                  let qte = $('#quantite_' + j).val();
                  let nouvelleQte = parseInt(qte || '0') + 1;
                  $('#quantite_' + j).val(nouvelleQte);

                  // Nettoyer la ligne en cours
                  $('#unitelib_' + prevNum).val('');
                  $('#unite_' + prevNum).val('');
                  $('#produit_' + prevNum).val('');
                  $('#produitlib_' + prevNum + 'libelle').val('');
                  $('#quantite_' + prevNum).val('');
                  $('#montant_' + prevNum).val('');

                  // Ne pas cocher, ne pas passer à la ligne suivante
                  return;
                }
              }

              // Produit nouveau → remplir la ligne
              $('#unitelib_' + prevNum).val(item.retour.split(";")[1]);
              $('#unite_' + prevNum).val(item.retour.split(";")[0]);
              $('#produit_' + prevNum).val(item.label);
              $('#produitlib_' + prevNum + 'libelle').val(item.value);
              $('#quantite_' + prevNum).val(1);
              $('#montant_' + prevNum).val(item.retour);

              // Cocher la case correspondante
              let checkbox = document.getElementById('checkbox' + prevNum);
              if (checkbox) checkbox.checked = true;

              // Aller à la ligne suivante
              if (nextInput) {
                nextInput.focus();
              }
            }
          });

          // Lancer l'autocomplétion sans rien faire d'autre ici
          $('#' + currentId).autocomplete('enable').autocomplete('search', event.target.value);
        }
      });
    }
  });
</script>
