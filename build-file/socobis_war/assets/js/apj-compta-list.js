(function (window, document) {
    "use strict";

    function normalize(value) {
        return String(value || "").normalize("NFD").replace(/[\u0300-\u036f]/g, "")
            .toLocaleLowerCase("fr").replace(/\s+/g, " ").trim();
    }

    function prepareExport(table) {
        var clone = table.cloneNode(true);
        Array.prototype.forEach.call(clone.querySelectorAll("thead th[data-apj-filter-label]"), function (header) {
            header.textContent = header.getAttribute("data-apj-filter-label");
        });
        Array.prototype.forEach.call(clone.querySelectorAll(".apj-account-row-hidden"), function (row) {
            row.classList.remove("apj-account-row-hidden");
        });
        Array.prototype.forEach.call(clone.querySelectorAll(".apj-account-empty"), function (row) {
            row.parentNode.removeChild(row);
        });
        return clone;
    }

    function init(root, tableIndex) {
        if (root.getAttribute("data-apj-account-ready") === "true") { return; }
        var table = root.querySelector("table[data-apj-account-table]");
        if (!table || !table.tHead || !table.tBodies.length) { return; }
        root.setAttribute("data-apj-account-ready", "true");

        var groups = [];
        var movements = [];
        var currentGroup = null;
        Array.prototype.forEach.call(table.tBodies[0].rows, function (row) {
            if (row.classList.contains("apj-account-heading")) {
                currentGroup = { structural: [row], movements: [] };
                groups.push(currentGroup);
            } else if (row.getAttribute("data-apj-row") === "movement") {
                movements.push(row);
                if (currentGroup) { currentGroup.movements.push(row); }
            } else if (currentGroup && !row.classList.contains("apj-grand-total")) {
                currentGroup.structural.push(row);
            }
        });

        var pagination = document.createElement("div");
        pagination.className = "pagination-bas-page";
        pagination.innerHTML = '<label class="apj-npp-control"><span class="apj-npp-label" multi-lang="">Résultats par page</span>' +
            '<select class="apj-npp-select" aria-label="Nombre de résultats par page">' +
            '<option value="0">0</option><option value="25">25</option><option value="50">50</option>' +
            '<option value="100">100</option><option value="200">200</option></select></label>' +
            '<h3 class="Body12pxRegular pagination-title m-0" aria-live="polite"></h3>' +
            '<nav aria-label="Pagination du tableau"><ul class="pagination">' +
            '<li><span class="page-link btn btn-secondary btn-small" data-apj-page-state></span></li>' +
            '<li class="page-item"><button type="button" class="page-link btn btn-secondary btn-small" data-apj-page-prev aria-label="Page précédente"><i class="material-symbols-rounded">chevron_left</i></button></li>' +
            '<li class="page-item"><button type="button" class="page-link btn btn-secondary btn-small" data-apj-page-next aria-label="Page suivante"><i class="material-symbols-rounded">chevron_right</i></button></li>' +
            '<li class="apj-expand-page-item"><button type="button" class="page-link btn btn-secondary btn-small" data-apj-page-expand aria-label="Agrandir le tableau" aria-expanded="false"><i class="expand-icon material-symbols-rounded">unfold_more</i></button></li>' +
            '</ul></nav>';
        root.parentNode.insertBefore(pagination, root.nextSibling);

        var emptyRow = document.createElement("tr");
        emptyRow.className = "apj-account-empty";
        emptyRow.style.display = "none";
        var emptyCell = document.createElement("td");
        emptyCell.colSpan = table.tHead.rows[0].cells.length;
        emptyCell.textContent = "Aucun résultat pour ces filtres";
        emptyRow.appendChild(emptyCell);
        var grandTotalRow = table.tBodies[0].querySelector(".apj-grand-total");
        table.tBodies[0].insertBefore(emptyRow, grandTotalRow || null);

        var npp = pagination.querySelector(".apj-npp-select");
        var count = pagination.querySelector(".pagination-title");
        var state = pagination.querySelector("[data-apj-page-state]");
        var previous = pagination.querySelector("[data-apj-page-prev]");
        var next = pagination.querySelector("[data-apj-page-next]");
        var expand = pagination.querySelector("[data-apj-page-expand]");
        var controls = [];
        var filters = {};
        var page = 1;

        function closeEditor(control) {
            control.classList.remove("is-editing");
            control.querySelector(".apj-table-column-filter-toggle").setAttribute("aria-expanded", "false");
        }

        Array.prototype.forEach.call(table.tHead.rows[0].cells, function (header) {
            if (!header.hasAttribute("data-apj-filter-column")) { return; }
            var column = header.cellIndex;
            var label = header.getAttribute("data-apj-filter-label") || header.textContent.trim();
            var inputId = "apj-account-filter-" + tableIndex + "-" + column;
            var control = document.createElement("div");
            control.className = "apj-table-column-filter";
            control.innerHTML = '<div class="apj-table-column-filter-summary">' +
                '<span class="apj-table-column-filter-label"></span>' +
                '<button type="button" class="apj-table-column-filter-toggle" aria-expanded="false" aria-pressed="false"><i class="material-symbols-rounded">search</i></button></div>' +
                '<div class="apj-table-column-filter-editor"><input class="apj-table-column-filter-input" type="text" autocomplete="off">' +
                '<button type="button" class="apj-table-column-filter-cancel">&times;</button></div>';
            control.querySelector(".apj-table-column-filter-label").textContent = header.textContent;
            header.textContent = "";
            header.appendChild(control);
            var toggle = control.querySelector(".apj-table-column-filter-toggle");
            var input = control.querySelector(".apj-table-column-filter-input");
            var cancel = control.querySelector(".apj-table-column-filter-cancel");
            input.id = inputId;
            input.placeholder = label;
            input.setAttribute("aria-label", "Filtrer " + label);
            toggle.setAttribute("aria-label", "Filtrer " + label);
            toggle.setAttribute("aria-controls", inputId);
            cancel.setAttribute("aria-label", "Effacer le filtre " + label);
            controls.push(control);

            toggle.addEventListener("click", function () {
                var opening = !control.classList.contains("is-editing");
                controls.forEach(closeEditor);
                if (opening) {
                    control.classList.add("is-editing");
                    toggle.setAttribute("aria-expanded", "true");
                    input.focus();
                    input.select();
                }
            });
            input.addEventListener("input", function () {
                var value = normalize(input.value);
                if (value) { filters[column] = value; } else { delete filters[column]; }
                control.classList.toggle("is-active", !!value);
                toggle.setAttribute("aria-pressed", value ? "true" : "false");
                page = 1;
                render();
            });
            input.addEventListener("keydown", function (event) {
                if (event.key === "Escape") { closeEditor(control); toggle.focus(); }
            });
            cancel.addEventListener("click", function () {
                if (input.value) {
                    input.value = "";
                    input.dispatchEvent(new Event("input"));
                    input.focus();
                } else {
                    closeEditor(control);
                    toggle.focus();
                }
            });
        });

        document.addEventListener("click", function (event) {
            controls.forEach(function (control) {
                if (!control.contains(event.target)) { closeEditor(control); }
            });
        });

        function matches(row) {
            return Object.keys(filters).every(function (column) {
                var cell = row.cells[Number(column)];
                return cell && normalize(cell.textContent).indexOf(filters[column]) !== -1;
            });
        }

        function render() {
            var matching = movements.filter(matches);
            var pageSize = parseInt(npp.value, 10) || 0;
            var pages = pageSize === 0 ? 1 : Math.max(1, Math.ceil(matching.length / pageSize));
            page = Math.min(page, pages);
            var start = pageSize === 0 ? 0 : (page - 1) * pageSize;
            var visible = pageSize === 0 ? matching : matching.slice(start, start + pageSize);
            var visibleSet = new Set(visible);

            movements.forEach(function (row) {
                row.classList.toggle("apj-account-row-hidden", !visibleSet.has(row));
            });
            groups.forEach(function (group) {
                var show = group.movements.some(function (row) { return visibleSet.has(row); }) ||
                    (group.movements.length === 0 && Object.keys(filters).length === 0 && page === 1);
                group.structural.forEach(function (row) {
                    row.classList.toggle("apj-account-row-hidden", !show);
                });
            });
            emptyCell.textContent = movements.length === 0 ? "Aucun mouvement disponible" : "Aucun résultat pour ces filtres";
            emptyRow.style.display = matching.length === 0 ? "" : "none";
            count.textContent = visible.length + " résultats sur " + matching.length;
            state.textContent = "Page: " + page + " sur " + pages;
            previous.disabled = page === 1;
            next.disabled = page === pages;
            previous.parentNode.classList.toggle("disabled", previous.disabled);
            next.parentNode.classList.toggle("disabled", next.disabled);
        }

        npp.addEventListener("change", function () { page = 1; render(); });
        previous.addEventListener("click", function () { if (page > 1) { page--; render(); } });
        next.addEventListener("click", function () { if (!next.disabled) { page++; render(); } });
        expand.addEventListener("click", function () {
            var expanded = root.classList.toggle("expand");
            expand.querySelector(".expand-icon").textContent = expanded ? "unfold_less" : "unfold_more";
            expand.setAttribute("aria-label", expanded ? "Réduire le tableau" : "Agrandir le tableau");
            expand.setAttribute("aria-expanded", expanded ? "true" : "false");
        });
        render();
    }

    function initAll() {
        Array.prototype.forEach.call(document.querySelectorAll("[data-apj-account-root]"), init);
    }

    window.ApjAccountTable = { initAll: initAll, prepareExport: prepareExport };
    if (document.readyState === "loading") {
        document.addEventListener("DOMContentLoaded", initAll);
    } else {
        initAll();
    }
})(window, document);
