<%--
  Apercu de fichier partage : modal + openPreview(), inclus une seule fois depuis
  pages/module.jsp (apres #butjsp). Toute page rendue via module.jsp peut donc appeler
  openPreview(url, kind, name, dlUrl) sans rien embarquer d'autre qu'un bouton.

  Consommateurs actuels :
    - facturefournisseur/facturefournisseur-fiche.jsp  (fichiers attaches, FileManager2?inline=1)
    - vente/proforma/proforma-fiche.jsp                (PDF genere, ExportPDF?inline=1)

  Le CSS est scope sur #filePreviewModal : il neutralise les overrides globaux sans
  toucher aux autres modals du site (voir les references en commentaire ci-dessous).
--%>
<style>
    /* --- Apercu fichier : neutralise les overrides globaux ---
       Tout est scope sur #filePreviewModal : aucun autre modal du site n'est affecte.
       Entre declarations !important c'est la specificite qui tranche, donc un selecteur
       id + classe bat les regles globales quel que soit l'ordre des feuilles de style. */

    /* apj-global-style.css:908  .modal-dialog{width:60%}
       stylecustom.css:634/639   .modal-dialog{width:75%/95% !important} */
    #filePreviewModal .modal-dialog {
        width: 92% !important;
        max-width: none;
    }
    /* stylecustom.css:352  .modal.in .modal-dialog{margin-top:55px!important} */
    #filePreviewModal.in .modal-dialog {
        margin-top: 24px !important;
    }
    /* apj-global-style.css:912  .modal-content{background:transparent;box-shadow:none}
       apj-global-style.css:1726 .modal-content{height:inherit!important} */
    #filePreviewModal .modal-content {
        background-color: #fff !important;
        box-shadow: 0 5px 15px rgba(0, 0, 0, .5) !important;
        border-radius: 8px;
        height: auto !important;
        overflow: hidden;
    }
    #filePreviewModal .modal-body {
        padding: 0;
        background: #525659; /* gris du viewer PDF : evite le flash blanc */
    }
    #filePreviewModal #previewFrame {
        width: 100%;
        height: 82vh;
        border: 0;
    }
    #filePreviewModal #previewImgWrap {
        width: 100%;
        height: 82vh;
        overflow: auto;
        text-align: center;
    }
    #filePreviewModal #previewImg {
        max-width: 100%;
        display: inline-block;
    }
</style>

<!-- Modal d'aperçu de fichier -->
<div class="modal fade" id="filePreviewModal" tabindex="-1" role="dialog" aria-labelledby="filePreviewModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Fermer">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title" id="filePreviewModalLabel">Aper&ccedil;u du fichier</h4>
      </div>
      <div class="modal-body">
        <iframe id="previewFrame" src="about:blank" style="display:none;"></iframe>
        <div id="previewImgWrap" style="display:none;"><img id="previewImg" alt="Aper&ccedil;u"/></div>
      </div>
      <div class="modal-footer">
        <a id="previewNewTab" href="#" target="_blank" rel="noopener" class="btn btn-default">Ouvrir dans un nouvel onglet</a>
        <a id="previewDownload" href="#" class="btn btn-success">T&eacute;l&eacute;charger</a>
        <button type="button" id="previewPrint" class="btn btn-primary">Imprimer</button>
        <button type="button" class="btn btn-default" data-dismiss="modal">Fermer</button>
      </div>
    </div>
  </div>
</div>

<script type="text/javascript">
function resetPreview() {
    var f = document.getElementById('previewFrame');
    var i = document.getElementById('previewImg');
    // about:blank et non '' : '' recharge l'URL de la page dans certains navigateurs
    if (f) { f.src = 'about:blank'; f.style.display = 'none'; }
    if (i) { i.removeAttribute('src'); }
    document.getElementById('previewImgWrap').style.display = 'none';
}

function openPreview(url, kind, name, dlUrl) {
    if (!url) {
        alert('Aucune URL de fichier disponible.');
        return;
    }
    resetPreview();

    // Pas de encodeURI ici : l'URL arrive deja percent-encodee du serveur. encodeURI
    // laisse passer & + = # (donc n'aide pas sur une query string) et double-encoderait
    // le % de %C2%B0, cassant les dossiers accentues.
    document.getElementById('filePreviewModalLabel').textContent = name || 'Apercu du fichier';
    document.getElementById('previewDownload').href = dlUrl || url;
    document.getElementById('previewNewTab').href   = url;   // inline=1 : ouvre vraiment

    if (kind === 'image') {
        document.getElementById('previewImg').src = url;
        document.getElementById('previewImgWrap').style.display = 'block';
    } else {
        var f = document.getElementById('previewFrame');
        f.src = url;
        f.style.display = 'block';
    }

    var btnPrint = document.getElementById('previewPrint');
    // pas d'impression pour une image : il n'y a pas d'iframe, donc pas de contentWindow
    btnPrint.style.display = (kind === 'image') ? 'none' : '';
    btnPrint.onclick = function () {
        var fr = document.getElementById('previewFrame');
        try {
            fr.contentWindow.focus();
            fr.contentWindow.print();
        } catch (e) {
            window.open(url, '_blank');   // repli si le viewer refuse l'appel
        }
    };

    if (window.jQuery && jQuery.fn.modal) {
        jQuery('#filePreviewModal').modal('show');
    } else {
        window.open(url, '_blank');   // bootstrap.js absent : degradation
    }
}

// jQuery est charge dans <head> (elements/css.jsp), bootstrap.js en fin de <body>
// (elements/js.jsp) : un binding delegue sur document fonctionne malgre cet ordre.
if (window.jQuery) {
    jQuery(document).on('hidden.bs.modal', '#filePreviewModal', resetPreview);
}
</script>
