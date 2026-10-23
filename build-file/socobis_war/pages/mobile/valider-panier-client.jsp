<%@page import="affichage.PageRecherche"%>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="user.UserEJB" %>
<%@ page import="panier.PanierLib" %>
<%@ page import="utilitaire.ConstanteEtat" %>
<%@ page import="bean.AdminGen" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% try{
    PanierLib t = new PanierLib();
    String[] listeCrt = {};
    String[] listeInt = {};
    String[] libEntete = {"puUniteLib"};
    String idClient = request.getParameter("idClient");
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    UserEJB u = (user.UserEJB) session.getAttribute("u");
    pr.setUtilisateur(u);
    if (!Utilitaire.champNull(idClient).isEmpty()) {
        pr.setAWhere(" AND idClient='"+idClient+"' and etat = "+ ConstanteEtat.getEtatCreer());
    }
    String lien = (String) session.getAttribute("lien");
    pr.setLien(lien);
    pr.creerObjetPage(libEntete, null);
    pr.setCssBoxExtraMobile("commande-box");
    pr.setCssTitreExtraMobile("Body14pxSemiBold search-result__title m-0");
    pr.setCssColExtraMobile("Body14pxRegular m-0 price-tag");
    pr.setVisibleColMobile(false);

    pr.setLienAjoutPanier(lien + "?but=mobile/apresPanier.jsp");
    pr.ajouterParamPanier("acte", "cancel");
    pr.ajouterParamPanier("bute", "mobile/valider-panier-client.jsp");
    pr.setNomChampQte("qte");
    pr.setColonneQte("qte");
    pr.setClasseAction("btn btn-tertiary btn-danger");
    pr.setIconeAction("close");
    pr.setLibelleAction("");

    pr.setFormatTitre("{idProduit} - {idProduitLib}");
    PanierLib[] data = (PanierLib[]) pr.getTableau().getData();
    double total = AdminGen.calculSommeDouble(data,"montantCalc");
    StringBuilder prix = new StringBuilder("{");
    for (int i = 0; i < data.length; i++) {
        if (i > 0) prix.append(",");
        prix.append("\"").append(data[i].getId()).append("\":").append(data[i].getPu());
    }
    prix.append("}");
%>
<script>window.PRIX_LIGNES = <%=prix%>;</script>
<div class="content-wrapper">
    <jsp:include page="/pages/elements/headerMobile.jsp">
        <jsp:param name="titre" value="Commandes"/>
    </jsp:include>
    <%=pr.getHtmlSearchMobile()%>
    <%=pr.getHtmlInterfaceMobile()%>
    <form id="form-panier-multi" method="post" action="<%=lien%>?but=mobile/apresPanier.jsp">
        <input type="hidden" name="idClient" value="<%=idClient%>">
        <input type="hidden" name="bute" value="mobile/valider-panier-client.jsp">
        <% for (PanierLib p : data) { %>
            <input type="hidden" name="ids" value="<%=p.getId()%>">
        <% } %>
        <div id="save-champs"></div>
    </form>
    <div class="mobile--total__container">
        <div class="mobile--total d-flex mb-5">
            <span class="Body14pxSemiBold">Total</span>
            <span class="h617pxSemibold" data-total-js><%=Utilitaire.formaterAr(total)%> MGA</span>
        </div>
        <div class="mobile--total__footer d-flex gap-2">
            <button type="submit" form="form-panier-multi" name="acte" value="annulerMultiple" class="btn btn-secondary w-33">Annuler</button>
            <button type="button" class="btn btn-secondary w-33" id="btn-enregistrer-modifs" disabled>Enregistrer</button>
            <button type="button" class="btn btn-primary w-33" id="btn-valider-panier"
                    data-toggle="modal" data-target="#panierModal">Valider</button>
        </div>
    </div>
    <div class="modal fade" id="panierModal" tabindex="-1" role="dialog" aria-labelledby="panierModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header nopadding borderless">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close" style="font-size: 40px;color: var(--Text-primary);text-shadow: none;position: absolute;top: 6px;right: 16px;z-index: 9999;">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <h5 class="modal-title h520pxSemibold" id="panierModalLabel">Confirmation</h5>
                    <p>Êtes-vous prêt à valider ces commandes ?</p>
                    <div class="mobile--total d-flex">
                        <span class="h617pxSemibold">Total</span>
                        <span class="h617pxSemibold"><%=Utilitaire.formaterAr(total)%> MGA</span>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="submit" form="form-panier-multi" name="acte" value="validerMultiple"  data-no-validate style="display: initial;text-align: center" class="btn btn-primary w-100">Confirmer</button>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
    document.addEventListener('DOMContentLoaded', () => {
        if (!window.PRIX_LIGNES) return;

        const boxes = Array.from(document.querySelectorAll('.commande-box'))
            .filter((b) => b.querySelector('form input[type="hidden"][name="id"]'));
        if (!boxes.length) return;

        const saveBtn  = document.getElementById('btn-enregistrer-modifs');
        const validBtn = document.getElementById('btn-valider-panier');

        const idDe = (box) => box.querySelector('form input[type="hidden"][name="id"]').value;
        const puDe = (box) => parseFloat(window.PRIX_LIGNES[idDe(box)]) || 0;
        const qteInput = (box) => box.querySelector('.input-with-addons input.form-control');
        const fmt = (n) => {
            const [ent, dec] = n.toFixed(2).split('.');
            return ent.replace(/\B(?=(\d{3})+(?!\d))/g, ' ') + '.' + dec;
        };

        boxes.forEach((b) => { const i = qteInput(b); if (i) i.dataset.initial = i.value; });

        const recalc = () => {
            let total = 0, dirty = false;
            boxes.forEach((box) => {
                const input = qteInput(box);
                if (!input) return;
                total += (parseInt(input.value, 10) || 0) * puDe(box);
                if (input.value !== input.dataset.initial) dirty = true;
            });
            document.querySelectorAll('[data-total-js]').forEach((el) => {
                el.textContent = fmt(total) + ' MGA';
            });
            if (saveBtn)  saveBtn.disabled  = !dirty;
            if (validBtn) validBtn.disabled = dirty;
        };

        document.addEventListener('input',  (e) => { if (e.target.closest('.commande-box')) recalc(); });
        document.addEventListener('change', (e) => { if (e.target.closest('.commande-box')) recalc(); });

        if (saveBtn) {
            saveBtn.addEventListener('click', () => {
                const form = document.getElementById('form-panier-multi');
                const zone = document.getElementById('save-champs');
                zone.innerHTML = '';

                // même ordre que les hidden "ids" du formulaire
                form.querySelectorAll('input[name="ids"]').forEach((hid) => {
                    const box = boxes.find((b) => idDe(b) === hid.value);
                    const input = box ? qteInput(box) : null;
                    const h = document.createElement('input');
                    h.type = 'hidden';
                    h.name = 'qtes';
                    h.value = input ? input.value : '';
                    zone.appendChild(h);
                });

                const acte = document.createElement('input');
                acte.type = 'hidden';
                acte.name = 'acte';
                acte.value = 'updateMultiple';
                zone.appendChild(acte);

                saveBtn.disabled = true;
                form.submit();
            });
        }
        recalc();
    });
</script>
<% } catch (Exception e) {
    e.printStackTrace();  %>
    <script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();</script>
<% }%>



