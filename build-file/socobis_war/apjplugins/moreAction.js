document.addEventListener('DOMContentLoaded', function() {
    const ellipsisList = document.querySelectorAll('.more_info');

    ellipsisList.forEach((ellipsis, index) => {
        ellipsis.id = `ellipsis-${index}`;
        const moreAction = ellipsis.nextElementSibling;
        moreAction.id = `more-action-${index}`;

        ellipsis.addEventListener('click', function(event) {
            event.stopPropagation();

            document.querySelectorAll('.mode_action').forEach(menu => {
                if (menu !== moreAction) {
                    menu.style.display = 'none';
                }
            });

            if (moreAction.style.display === 'block') {
                moreAction.style.display = 'none';
                console.log('HELLO LA FAMILLE LASA BLOCK')
            } else {
                moreAction.style.position = '';
                moreAction.style.left = '';
                moreAction.style.top = '';
                moreAction.style.display = 'block';
                console.log('HELLO LA FAMILLE LASA NONE')
                const rect = ellipsis.getBoundingClientRect();
            }
        });

        // ellipsis.addEventListener('contextmenu', function(event) {
        //     event.preventDefault();
        //     event.stopPropagation();
        //     document.querySelectorAll('.mode_action').forEach(menu => {
        //         if (menu !== moreAction) {
        //             menu.style.display = 'none';
        //         }
        //     });
        //     moreAction.style.position = 'absolute';
        //     moreAction.style.left = event.pageX + 'px';
        //     moreAction.style.display = 'block';
        //     console.log('CLIC DROIT SUR ELLIPSIS');
        // });
    });

    // const tableRows = document.querySelectorAll('tr');
    //
    // tableRows.forEach(row => {
    //     const ellipsis = row.querySelector('.more_info');
    //     if (ellipsis) {
    //         const moreAction = ellipsis.nextElementSibling;
    //
    //         const cells = row.querySelectorAll('td');
    //
    //         cells.forEach((cell, cellIndex) => {
    //             if (cellIndex > 0) {
    //                 cell.addEventListener('contextmenu', function(event) {
    //                     event.preventDefault();
    //                     event.stopPropagation();
    //                     document.querySelectorAll('.mode_action').forEach(menu => {
    //                         if (menu !== moreAction) {
    //                             menu.style.display = 'none';
    //                         }
    //                     });
    //                     moreAction.style.position = 'absolute';
    //                     moreAction.style.left = event.pageX + 'px';
    //                     moreAction.style.display = 'block';
    //                     console.log('CLIC DROIT SUR CELLULE DU TABLEAU');
    //                 });
    //             }
    //         });
    //     }
    // });

    document.addEventListener('click', function() {
        document.querySelectorAll('.mode_action').forEach(menu => {
            menu.style.display = 'none';
        });
    });

    document.querySelectorAll('.mode_action').forEach(menu => {
        menu.addEventListener('click', function(event) {
            event.stopPropagation();
        });
    });
});