#!/bin/bash
# Main menu bash code

export MYSQL_PWD=Iamsherlocked#2.0
shopt -s extglob

menu() {
    # Initialize variables
    MODE="prompt"
    PROMPT="?"
    OPTIONS=()
    DATA=()
    EXITOPTION="Exit"

    # Read command line arguments
    while (( "$#" )); do
        case "$1" in
            -o|--option|--options)
                MODE="options"
                shift
            ;;
            -d|--data)
                MODE="data"
                shift
            ;;
            -od|--echo-option|--echo-options)
                MODE="echoopts"
                shift
            ;;
            -x|--exit-option)
                MODE="exitopt"
                shift
            ;;
            -*|--*=) # unsupported flags
                echo "Error: Unsupported flag $1"                                                    >&2
                echo "Usage: ./menu.sh [prompt] -o option1 [option2 [...]] [-d data1 [data2 [...]]]" >&2
                echo "       See script comments for more details."                                  >&2
                exit -1
            ;;
            *) # interpret positional arguments
                case "$MODE" in
                    prompt)
                        PROMPT=$1
                    ;;
                    options)
                        OPTIONS[${#OPTIONS[@]}]=$1
                    ;;
                    data)
                        DATA[${#DATA[@]}]=$1
                    ;;
                    echoopts)
                        OPTIONS[${#OPTIONS[@]}]=$1
                        DATA[${#DATA[@]}]=$1
                    ;;
                    exitopt)
                        EXITOPTION=$1
                    ;;
                esac
                shift
            ;;
        esac
    done

    # Argument parsing done.
    # 
    # $PROMPT       String      Contains the prompt to display after the menu.
    # $OPTIONS[]    String[]    Contains options to offer.
    # $DATA[]       String[]    Contains return values to return based on selection.
    # $EXITOPTION   String      Contains the label for the final X) Cancel/exit option.

    # Loop through options to display menu
    for i in ${!OPTIONS[@]}; do
        let INDEX=i+1
        echo "$INDEX) ${OPTIONS[i]}"
    done
    echo ""
    echo "X) $EXITOPTION"
    echo ""

    # Initialize variables
    SELECTION=0
    VALID=0
    FIRSTLOOP=1
    RETVAL=-1

    # Repeatedly prompt the user for input, until we get valid input
    while (( $VALID == 0 )); do
        if (( $FIRSTLOOP == 0 )); then
            PROMPT="Invalid selection. Type an option from above: "
        fi
        FIRSTLOOP=0
        read -p "$PROMPT" SELECTION
        
        case $SELECTION in
            x|X)                # If they select X, return zero.
                RETVAL=0
                VALID=1
            ;;
            +([0-9]))           # If they select a number, check if it's valid, then return the corresponding data.
                let INDEX=$SELECTION-1
                if (( $INDEX >= 0 && $INDEX < ${#OPTIONS[@]} )); then
                    RETVAL=${DATA[INDEX]}
                    if [ -z "$RETVAL" ]; then
                        let RETVAL=INDEX+1
                    fi
                    VALID=1
                fi
            ;;
        esac
    done

    # Return value will be stored in a global variable FUNC_RET.
    FUNC_RET="$RETVAL"
}

sqlGeneratedMenu() {
    # Initialize variables
    SGMPROMPT=$1
    SGMQUERY=$2
    if [ "$3" = "" ]; then
        SGMERROR="Error: No results in provided SELECT statement."
    else
        SGMERROR=$3
    fi
    if [ "$4" = "" ]; then
        SGMEXIT="\"Exit\""
    else
        SGMEXIT="\"$4\""
    fi
    
    # Execute SQL Query
    IFS=$'\r\n' QUERYRESULTTABLE=( $(mysql -N -u root library -e "$SGMQUERY") )
    
    if [ "${#QUERYRESULTTABLE[@]}" -lt 1 ] ; then
        # Show error if the query returned no values.
        echo "$SGMERROR"
        FUNC_RET=-1
    else
        MENU_OPTIONS=()
        MENU_DATA=()
    
        # Iterate through query results, store columns into arrays.
        for i in ${!QUERYRESULTTABLE[@]}; do
            IFS=$'\t' read MENU_OPTION MENU_DATUM <<< "${QUERYRESULTTABLE[i]}"
            MENU_OPTIONS[$i]=$MENU_OPTION
            MENU_DATA[$i]=$MENU_DATUM
        done
        
        # Build "options" arguments
        SGMMENUOPTIONS=""
        for i in ${!MENU_OPTIONS[@]}; do
            SGMMENUOPTIONS="$SGMMENUOPTIONS \"${MENU_OPTIONS[i]}\""
        done
        
        # Build "data" arguments
        SGMMENUDATA=""
        for i in ${!MENU_DATA[@]}; do
            SGMMENUDATA="$SGMMENUDATA \"${MENU_DATA[i]}\""
        done
        
        # Call menu()
        eval "menu \"$SGMPROMPT\" -o $SGMMENUOPTIONS -d $SGMMENUDATA -x $SGMEXIT"
    fi
}

sqlValidatedInput() {
    SQLVISQLSTRING=$1
    SQLVIPROMPT=$2
    SQLVIERROR=$3

    SVI=0
    SQLVIVALIDINPUT=0
    while (( $SQLVIVALIDINPUT == 0 )); do
        read -p "$SQLVIPROMPT (or leave blank to cancel): " SVI
        
        if [ "$SVI" = "" ]; then
            SVI=0
            SQLVIVALIDINPUT=1
        else
            eval "IFS=$'\n' SQLVISUCCESS=( \$(mysql -N -u root library -e \"$SQLVISQLSTRING\") )"
            if [ "$SQLVISUCCESS" = "1" ]; then
                SQLVIVALIDINPUT=1
            else
                eval "echo \"$SQLVIERROR\""
            fi
        fi
    done

    FUNC_RET=$SVI
}

#####################################################################
# AUTHOR Anthony Pergrossi
#####################################################################
mainMenu() {
    keepDoingMainMenu=1
    while [ $keepDoingMainMenu -ne 0 ]; do
        clear
        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        echo "  ANTHONY'S ANGELS LIBRARY MANAGEMENT SYSTEM  "
        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        echo
        menu "Select your role: " -o "Borrower" "Librarian" "Admin"
        role="$RETVAL"
        case $role in
            1) borrowerLogin ;;
            2) readLibrarianMenu ;;
            3) adminMenu ;;
            0)
                keepDoingMainMenu=0;
                clear
                echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
                echo "  ANTHONY'S ANGELS LIBRARY MANAGEMENT SYSTEM  "
                echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
                echo 
                echo "Goodbye."
                echo
            ;;
        esac
    done
}


# AUTHOR Anthony Pergrossi
libBranMenu(){
    keepDoingLibraryManagement=1
    while [ $keepDoingLibraryManagement -ne 0 ]; do
        clear
        echo "~~~~~~~~~~~~~~~~~~~~~~~"
        echo "  LIBRARY BRANCH MENU  "
        echo "~~~~~~~~~~~~~~~~~~~~~~~"
        echo 
        menu "What would you like to do to the library branch records? " -o "Add" "Update" "Delete"
        
        choice=$FUNC_RET
        case $choice in
            0)
                keepDoingLibraryManagement=0
                echo
                echo "Returning to previous menu."
                sleep 2
            ;;
            1) addLibBranch ;;
            2) updateLibBranch ;;
            3) deleteLibBranch ;;
        esac
    done
}

# AUTHOR Anthony Pergrossi
addLibBranch() {
	echo
    SQL='SELECT NOT EXISTS (SELECT 1 FROM tbl_library_branch lb WHERE lb.branchName = \"$SVI\");'
    PROMPT="New branch name?    >"
    ERROR='Error: A library branch already has the name \"$SVI\".'
    sqlValidatedInput "$SQL" "$PROMPT" "$ERROR"
    newBranchName=$FUNC_RET
    if [ "$newBranchName" = "0" ]; then
		echo
		echo "Branch creation cancelled."
		sleep 2
	else
		read -p "New branch address? >" newBranchAddress
		
		mysql --table -u root library -e "call addBranch(\"$newBranchName\", \"$newBranchAddress\")";
		
		echo "New branch added."
		sleep 2
	fi
}

# AUTHOR Anthony Pergrossi
updateLibBranch() {
	echo
    sqlGeneratedMenu "Select library branch to update. " "SELECT b.branchName, b.branchId FROM tbl_library_branch b;" "" "Cancel"
    updateBranchID=$FUNC_RET
    
    if [ "$updateBranchID" -ne 0 ]; then
        echo
        echo "Updating branch. Current info:"
        mysql --table -u root library -e "SELECT * FROM tbl_library_branch WHERE branchID = \"$updateBranchID\""
        
        SQL='SELECT NOT EXISTS (SELECT 1 FROM tbl_library_branch lb WHERE lb.branchName = \"$SVI\");'
        PROMPT="Branch new name? (N/A for no change)    >"
        ERROR='Error: A library branch already has the name \"$SVI\".'
        sqlValidatedInput "$SQL" "$PROMPT" "$ERROR"
        
        if [ "$FUNC_RET" = "0" ]; then
            echo
            echo "Cancelling branch update."
            sleep 2
        else
            updateBranchName=$FUNC_RET
            
            read -p "Branch new address? (N/A for no change) >" updateBranchAddress
            
            mysql --table -u root library -e "call updateBranch(\"$updateBranchID\", \"$updateBranchName\", \"$updateBranchAddress\")";
            
            echo "Branch information updated."
            sleep 2
        fi
    else
        echo
        echo "Cancelling branch update."
        sleep 2
    fi
}

# AUTHOR Anthony Pergrossi
deleteLibBranch() {
	echo
    sqlGeneratedMenu "Select library branch to delete. " "SELECT b.branchName, b.branchId FROM tbl_library_branch b;"
    deleteBranchID=$FUNC_RET
    
    echo
    mysql -N -u root library -e "SELECT * FROM tbl_library_branch WHERE branchID = \"$deleteBranchConfirm\"";
    echo
    
    echo "Are you sure you would like to delete this library branch?"
    echo "This will remove ALL branch data, including book loans and copies."
    mysql --table -u root library -e "SELECT * FROM tbl_library_branch WHERE branchID = \"$deleteBranchID\""
    read -p  "Type DELETE to delete, or anything else to cancel. >" deleteBranchConfirm
    
    if [ "$deleteBranchConfirm" = "DELETE" ]; then
        echo "Deleting library branch."
        mysql -N -u root library -e "call deleteBranch(\"$deleteBranchID\")";
        echo "Branch deleted."
        sleep 2
    else
        echo "Deletion cancelled."
        sleep 2
    fi
}

# AUTHOR Anthony
updateBookMenu() {
    keepDoingUpdateBookMenu=1
    while [ $keepDoingUpdateBookMenu -ne 0 ]; do
        clear
        echo "~~~~~~~~~~~~~~~~~~~~"
        echo "  UPDATE BOOK MENU  "
        echo "~~~~~~~~~~~~~~~~~~~~"
        echo 
        echo "Updating book:"
        mysql --table -u root library -e "SELECT * FROM tbl_book WHERE bookId = \"$bkID\""
        echo 
        menu "What would you like to do to this book? " -o "Change Title/Publisher" "Add Authors" "Remove Authors" "Add Genres" "Remove Genres" -x "Return to Book Menu"
        
        choice=$FUNC_RET
        case $choice in
            1) updateBookTitlePub ;;
            2) updateBookAddAuthors ;;
            3) updateBookRemoveAuthors ;;
            4) updateBookAddGenres ;;
            5) updateBookRemoveGenres ;;
            0)
                keepDoingUpdateBookMenu=0
                echo
                echo "Returning to previous menu."
                sleep 2
            ;;
        esac
    done
}

updateBookTitlePub() {
    echo
    echo "Updating:"
    mysql --table -u root library -e "SELECT * FROM tbl_book WHERE bookId = \"$bkID\""
    echo
    echo "Please enter the new Title of the book or enter N/A for no change:"
    read bkTitle
    echo
    echo "Please enter the new publisher's ID of the book or enter N/A for no change: "
    read pubID
    
    if [ "$pubID" = "N/A" ]; then
        pubID=0
    fi
    
    echo
    echo "Updating book record..."
    mysql --table -u root library -e "CALL updateBook(\"$bkID\", \"$bkTitle\", \"$pubID\")"
    echo "Book record updated."
    echo
    sleep 2
}

#AUTHOR Anthony
updateBookAddAuthors() {
    keepDoingAddAuthors=1
    while [ $keepDoingAddAuthors -ne 0 ]; do
		echo
        sqlGeneratedMenu "Select an author to add to the book: " "SELECT a.authorName, a.authorId FROM tbl_author a WHERE NOT EXISTS(SELECT 1 FROM tbl_book_authors ba WHERE ba.authorId = a.authorId AND ba.bookId = $bkID)" "No more authors left to add." "Done adding authors."
        authID=$FUNC_RET
        case $authID in
            0|-1)
                keepDoingAddAuthors=0
                echo
                echo "Returning to previous menu."
                sleep 2
            ;;
            *)
                mysql --table -u root library -e "CALL addExistingAuthorAdmin(\"$authID\", \"$bkID\")"
            ;;
        esac
    done
}

#AUTHOR Anthony
updateBookAddGenres() {
    keepDoingAddGenres=1
    while [ $keepDoingAddGenres -ne 0 ]; do
        echo
        sqlGeneratedMenu "Select a genre to add to the book: " "SELECT g.genre_name, g.genre_id FROM tbl_genre g WHERE NOT EXISTS(SELECT 1 FROM tbl_book_genres bg WHERE bg.genre_id = g.genre_id AND bg.bookId = $bkID)" "No more genres left to add." "Done adding genres."
        genID=$FUNC_RET
        case $genID in
            0|-1)
                keepDoingAddGenres=0
                echo
                echo "Returning to previous menu."
                sleep 2
            ;;
            *)
                mysql --table -u root library -e "CALL addExistingGenreAdmin(\"$genID\", \"$bkID\")"
            ;;
        esac
    done
}

#AUTHOR Anthony
updateBookRemoveAuthors() {
    keepDoingRemoveAuthors=1
    while [ $keepDoingRemoveAuthors -ne 0 ]; do
        echo
        sqlGeneratedMenu "Select an author to remove from the book: " "SELECT a.authorName, a.authorId FROM tbl_author a WHERE EXISTS(SELECT 1 FROM tbl_book_authors ba WHERE ba.authorId = a.authorId AND ba.bookId = $bkID)" "No more authors left to remove." "Done removing authors."
        authID=$FUNC_RET
        case $authID in
            0|-1)
                keepDoingRemoveAuthors=0
                echo
                echo "Returning to previous menu."
                sleep 2
            ;;
            *)
                mysql --table -u root library -e "CALL removeExistingAuthorAdmin(\"$authID\", \"$bkID\")"
            ;;
        esac
    done
}

#AUTHOR Anthony
updateBookRemoveGenres() {
    keepDoingRemoveGenres=1
    while [ $keepDoingRemoveGenres -ne 0 ]; do
        echo
        sqlGeneratedMenu "Select a genre to remove from the book: " "SELECT g.genre_name, g.genre_id FROM tbl_genre g WHERE EXISTS(SELECT 1 FROM tbl_book_genres bg WHERE bg.genre_id = g.genre_id AND bg.bookId = $bkID)" "No more genres left to remove." "Done removing genres."
        genID=$FUNC_RET
        case $genID in
            0|-1)
                keepDoingRemoveGenres=0
                echo
                echo "Returning to previous menu."
                sleep 2
            ;;
            *)
                mysql --table -u root library -e "CALL removeExistingGenreAdmin(\"$genID\", \"$bkID\")"
            ;;
        esac
    done
}

# Menu to make changes to the book table
bookMenu(){
    keepDoingBookMenu=1
    while [ $keepDoingBookMenu -ne 0 ]; do
        clear
        echo "~~~~~~~~~~~~~"
        echo "  BOOK MENU  "
        echo "~~~~~~~~~~~~~"
        echo 
        menu "What would you like to do to the book records? " -o "Add" "Update" "Delete" -x "Return to Admin Menu"
        
        choice=$FUNC_RET
        case $choice in
            1) addBook ;;
            2) updateBook ;;
            3) deleteBook ;;
            0)
                keepDoingBookMenu=0
                echo
                echo "Returning to previous menu."
                sleep 2
            ;;
        esac
    done
}

# Add a new book record
addBook(){
    echo
    sqlValidatedInput "SELECT NOT EXISTS (SELECT 1 FROM tbl_book b WHERE b.title = \\\"\$SVI\\\");" "Please enter the title of the book: " "Error: A book with that title already exists."
    bookTitle=$FUNC_RET
    
    if [ "$bookTitle" = "0" ]; then
        echo
        echo "Cancelling book add."
        sleep 2
    else
        selectPublisher
        pubID=$FUNC_RET
        echo
        selectAuthor
        authID=$FUNC_RET
        echo
        selectGenre
        genID=$FUNC_RET
        
        echo
        echo "Adding book to database."
        mysql --table -u root library -e "CALL addBook(\"$bookTitle\", \"$pubID\", \"$genID\", \"$authID\")"
        echo "Book added."
        sleep 2
    fi
}

# Update a book record
updateBook(){
    echo
    sqlGeneratedMenu "Select book to update. " "SELECT b.title, b.bookId FROM tbl_book b;"
    bkID=$FUNC_RET
    
    if [ "$bkID" -ge 1 ]; then
        updateBookMenu
    fi
}

# Delete a book record
deleteBook(){
    echo
    sqlGeneratedMenu "Select book to delete. " "SELECT b.title, b.bookId FROM tbl_book b;"
    bkID=$FUNC_RET
    
    if [ "$bkID" -ge 1 ]; then
        echo
        echo "Are you sure you would like to delete this book record?"
        echo "This will remove ALL this book's data, including book loans and copies."
        mysql --table -u root library -e "SELECT * FROM tbl_book WHERE bookId = \"$bkID\""
        read -p  "Type DELETE to delete, or anything else to cancel. >" deleteBookConfirm
        
        if [ "$deleteBookConfirm" = "DELETE" ]; then
            echo
            echo "Deleting book..."
            mysql --table -u root library -e "CALL deleteBook(\"$bkID\")"
            echo "Book record deleted."
            echo
            sleep 2
        else
            echo "Deletion cancelled."
            echo
            sleep 2
        fi
    else
        echo "Deletion cancelled."
        echo
        sleep 2
    fi
}

selectPublisher() {
    echo
    sqlGeneratedMenu "Select a publisher: " "SELECT p.publisherName, p.publisherID FROM tbl_publisher p" "" "Cancel Selecting Publisher"
}

selectAuthor() {
    echo
    sqlGeneratedMenu "Select an author: " "SELECT a.authorName, a.authorID FROM tbl_author a" "" "Cancel Selecting Author"
}

selectGenre() {
    echo
    sqlGeneratedMenu "Select a genre: " "SELECT g.genre_name, g.genre_id FROM tbl_genre g" "" "Cancel Selecting Genre"
}

# AUTHOR Anthony Pergrossi
alterLoanMenu(){
    keepDoingAlterLoans=1
    while [ $keepDoingAlterLoans -ne 0 ]; do
        clear
        echo "~~~~~~~~~~~~~~~~~~~~~~~"
        echo "  ALTER LOAN DUE DATE  "
        echo "~~~~~~~~~~~~~~~~~~~~~~~"
        echo 
        
        SQL='SELECT EXISTS (SELECT 1 FROM tbl_borrower b WHERE b.cardNo = \"$SVI\");'
        PROMPT="Borrower's card number?"
        ERROR='Error: No borrower exists with card number \"$SVI\".'
        sqlValidatedInput "$SQL" "$PROMPT" "$ERROR"
        cardNo=$FUNC_RET
        
        if [ "$cardNo" -ne 0 ]; then
            LOANCOUNT=$(mysql -N -u root library -e "SELECT COUNT(1) FROM tbl_book_loans bl WHERE bl.cardNo = $cardNo AND bl.returnedDate IS NULL;")
            if [ "$LOANCOUNT" -gt 0 ]; then
                echo
                echo "Active loans for card number \"$cardNo\": "
                mysql --table -u root library -e "CALL getLoans(\"$cardNo\")"
                read -p "Please input the branch ID: " branchId
                read -p "Please input the book ID:   " bookId
                echo
                mysql --table -u root library -e "SELECT dueDate AS \"Due Date\", getDaysUntil(dueDate) AS \"Days Until Due\" FROM tbl_book_loans WHERE cardNo = \"$cardNo\" AND branchId = \"$branchId\" AND bookId = \"bookId\" AND returnedDate IS NOT NULL;"
                read -p "Please input the new due date (YYYY-MM-DD): " newDate
                echo
                mysql --table -u root library -e "CALL alterLoanSetDueDate(\"$bookId\", \"$branchId\", \"$cardNo\", \"$newDate\", @daysUntil)"
                echo "Due date changed."
                echo 
                sleep 2
            else
                keepDoingAlterLoans=0
                echo
                echo "This borrower has no active book loans."
                echo
                echo "Returning to previous menu."
                sleep 2
            fi
        else
            keepDoingAlterLoans=0
            echo
            echo "Returning to previous menu."
            sleep 2
        fi
    done
}




#########################################################
########Author Sayana
#########################################################
borrowerLogin(){
    clear
 	echo "~~~~~~~~~~~~~~~~~~"
	echo "  BORROWER LOGIN  "
	echo "~~~~~~~~~~~~~~~~~~"
	
	SQL='SELECT EXISTS (SELECT 1 FROM tbl_borrower b WHERE b.cardNo = \"$SVI\");'
	PROMPT="Enter the your Card Number: "
	ERROR='Error: Borrower card number \"$SVI\" does not exist.'
	sqlValidatedInput "$SQL" "$PROMPT" "$ERROR"	
	cardNo=$FUNC_RET
    
    if [ $cardNo -ne 0 ]; then
        borrowerName=$(mysql -N -u root library -e "SELECT b.name FROM tbl_borrower b WHERE b.cardNo = \"$cardNo\"")
        borrowerMenu
    fi
}

 borrowerMenu(){
    STAYINBORROWERMENU=1
    
    while [ $STAYINBORROWERMENU -ne 0 ]; do
        clear
        echo "~~~~~~~~~~~~~~~~~"
        echo "  BORROWER MENU  "
        echo "~~~~~~~~~~~~~~~~~"
        echo 
        echo "Welcome, $borrowerName (card #$cardNo)!"
        echo 
        menu "What would you like to do today: " -o "Check Out a Book" "Return a Book" -x "Return to Main Menu"

        option=$FUNC_RET
        case $option in
            0)
                STAYINBORROWERMENU=0
            ;;
            1)
                clear
                echo "~~~~~~~~~~~~~~~~~"
                echo "  CHECKOUT MENU  "
                echo "~~~~~~~~~~~~~~~~~"
                echo 
                sqlGeneratedMenu "Select which library to checkout a book from: " "SELECT branchName, branchId FROM tbl_library_branch" "" "Go Back to Checkout/Return Menu"
                BranchId="$FUNC_RET"
                if [ $BranchId -le 0 ]; then
                    echo
                    echo "Returning to previous menu."
                    sleep 2
                else
                    clear
                    echo "~~~~~~~~~~~~~~~~~"
                    echo "  CHECKOUT MENU  "
                    echo "~~~~~~~~~~~~~~~~~"
                    echo 
                    sqlGeneratedMenu "Select which book to checkout: " "SELECT getBookTitleFromID(bookID), bookId FROM tbl_book_copies WHERE branchId = \"$BranchId\" AND noOfCopies > 0" "" "Go Back to Checkout/Return Menu"
                    BookId="$FUNC_RET"
                    if [ $BookId -le 0 ]; then
                        echo
                        echo "Returning to previous menu."
                        sleep 2
                    else
                        checkoutBook
                        sleep 2
                    fi
                fi
            ;;
            2)
                clear
                echo "~~~~~~~~~~~~~~~"
                echo "  RETURN MENU  "
                echo "~~~~~~~~~~~~~~~"
                echo 
                sqlGeneratedMenu "Select which library to return a book to: " "SELECT b.branchName, b.branchId FROM tbl_library_branch b JOIN tbl_book_loans bl ON b.branchId = bl.branchId WHERE bl.cardNo = $cardNo AND bl.returnedDate IS NULL GROUP BY b.branchId;" "Error: You do not have any books checked out." "Go Back to Checkout/Return Menu"
                BranchId="$FUNC_RET"
                if [ $BranchId -le 0 ]; then
                    echo
                    echo "Returning to previous menu."
                    sleep 2
                else
                    clear
                    echo "~~~~~~~~~~~~~~~"
                    echo "  RETURN MENU  "
                    echo "~~~~~~~~~~~~~~~"
                    echo
                    sqlGeneratedMenu "Select which book to return: " "SELECT getBookTitleFromID(bl.bookId), bl.bookID FROM tbl_book_loans bl WHERE bl.cardNo = \"$cardNo\" AND bl.branchId = \"$BranchId\" AND bl.returnedDate IS NULL;" "Error: you do not have any books checked out from that library." "Go Back to Checkout/Return Menu"
                    BookId="$FUNC_RET"
                    if [ $BookId -le 0 ]; then
                        echo
                        echo "Returning to previous menu."
                        sleep 2
                    else
                        returnBook
                        sleep 2
                    fi
                fi
            ;;
        esac
    done
}

checkoutBook() {
    mysql --table -u root library -e "call borrowBook(\"$BookId\", \"$BranchId\", \"$cardNo\")";
}

returnBook() {
    mysql --table -u root library -e "call returnBook(\"$BookId\", \"$BranchId\", \"$cardNo\")";
}

#Librarian menu
# AUTHOR Sayana
readLibrarianMenu(){
	clear
 	echo "~~~~~~~~~~~~~~~~~~~~"
	echo "  BRANCH SELECTION  "
	echo "~~~~~~~~~~~~~~~~~~~~"
    echo
    sqlGeneratedMenu "Enter the Branch Id you manage: " "SELECT branchName, branchId FROM tbl_library_branch" "" "Return to Main Menu"
	bchId=$FUNC_RET
    
    if [ $bchId -gt 0 ]; then
        librarianMenu
    fi
}

# AUTHOR Sayana
librarianMenu(){
    STAYINLIBRARIANMENU=1
    
    while [ $STAYINLIBRARIANMENU -ne 0 ]; do
		clear
		echo "~~~~~~~~~~~~~~~~~~"
		echo "  LIBRARIAN MENU  "
		echo "~~~~~~~~~~~~~~~~~~"
		echo
     
        menu "What would you like to do today: " -o "Update the details of the library" "Update no of copies of book to the Branch" -x "Return to Main Menu"

        option=$FUNC_RET
        case $option in
            0)
                STAYINLIBRARIANMENU=0
            ;;
            1)
                updateLibraryDetails
            ;;
            2)
                updateLibraryCopies
            ;;
        esac
    done
}

# AUTHOR Sayana
updateLibraryDetails() {
	echo
	echo "This is the Branch name and Branch Address for the Branch ID you have chosen"
	echo

	mysql --table -u root library -e "SELECT lb.branchName, lb.branchAddress FROM tbl_library_branch lb WHERE lb.branchId = \"$bchId\""

	echo
	read -p "Please enter new branch name or enter N/A for no change: " bchName
	echo
	read -p "Please enter new branch address or enter N/A for no change: " bchAddress
	echo
    
    mysql --table -u root library -e "call updateLibDetails( \"$bchId\", \"$bchName\", \"$bchAddress\")";
	sleep 2
}

# AUTHOR Sayana
updateLibraryCopies() {
	echo
	echo "Books we have in this branch"
	mysql --table -u root library -e "SELECT b.bookId AS ID, b.title AS Title, getBookCopies(b.bookID, \"$bchId\") AS Copies FROM tbl_book b;"
    
	echo
	read -p "Pick the Bookid you want to add copies of, to your branch:" selectedBook
    
	echo
	mysql --table -u root library -e "SELECT b.bookId AS ID, b.title AS Title, getBookCopies(b.bookID, \"$bchId\") AS Copies FROM tbl_book b WHERE b.bookId = \"$selectedBook\";"
	read -p "Enter new number of copies: " newNoOfCopies
    
	echo
    mysql --table -u root library -e "call addCopies(\"$selectedBook\", \"$bchId\", \"$newNoOfCopies\")";
    sleep 2
}

########################################################
### Author Janet
########################################################

adminMenu(){
    keepDoingAdminMenu=1
    while [ $keepDoingAdminMenu -ne 0 ]; do
        clear
        echo "~~~~~~~~~~~~~~~~~~~~~~"
        echo "  ADMINISTRATOR MENU  "
        echo "~~~~~~~~~~~~~~~~~~~~~~"
        echo 
        menu "Which information would you like to make changes to? " \
        -o "Book" "Author" "Genre" "Publisher" "Library Branch" "Borrower" "Override Due Date for a Book Loan" \
        -x "Return to Main Menu"
        
        choice=$FUNC_RET
        case $choice in
            1) bookMenu ;;
            2) authorMenu ;;
            3) genreMenu ;;
            4) pubMenu ;;
            5) libBranMenu ;;
            6) borrMenu ;;
            7) alterLoanMenu ;;
            0)
                keepDoingAdminMenu=0
                echo
                echo "Returning to previous menu."
                sleep 2
            ;;
        esac
    done
}

authorMenu() {
    keepDoingAuthorMenu=1
    while [ $keepDoingAuthorMenu -ne 0 ]; do
        clear
        echo "~~~~~~~~~~~~~~~"
        echo "  AUTHOR MENU  "
        echo "~~~~~~~~~~~~~~~"
        echo 
        menu "What would you like to do to the author records? " -o "Add" "Update" "Delete" -x "Return to Admin Menu"
        
        choice=$FUNC_RET
        case $choice in
            1) addAuthor ;;
            2) updateAuthor ;;
            3) deleteAuthor ;;
            0)
                keepDoingAuthorMenu=0
                echo
                echo "Returning to previous menu."
                sleep 2
            ;;
        esac
    done
}

addAuthor() {
    echo
    sqlValidatedInput "SELECT NOT EXISTS (SELECT 1 FROM tbl_author a WHERE a.authorName = \\\"\$SVI\\\");" "Please enter the new author's name: " "Error: An author with that name already exists."
    authName=$FUNC_RET
    
    if [ "$authName" = "0" ]; then
        echo
        echo "Cancelling author add."
        sleep 2
    else
        echo
        echo "Adding author to database."
        mysql --table -u root library -e "CALL addAuthorAdmin(\"$authName\")"
        echo "Author added."
        sleep 2
    fi
}

updateAuthor() {
    echo
    sqlGeneratedMenu "Select author to update. " "SELECT a.authorName, a.authorId FROM tbl_author a;"
    authID=$FUNC_RET
    
    if [ "$authID" -ne 0 ]; then
        echo
        echo "Updating:"
        mysql --table -u root library -e "SELECT * FROM tbl_author WHERE authorId = \"$authID\""
        echo
        echo "Please enter the new name of the author or enter N/A for no change:"
        read authName
        
        echo
        echo "Updating author..."
        mysql --table -u root library -e "CALL updateAuAdmin(\"$authID\", \"$authName\")"
        echo "Author record updated."
        echo
        sleep 2
    fi
}

deleteAuthor() {
    echo
    sqlGeneratedMenu "Select author to delete. " "SELECT a.authorName, a.authorId FROM tbl_author a;"
    authID=$FUNC_RET
    
    if [ "$authID" -ne 0 ]; then
        echo
        echo "Are you sure you would like to delete this author record?"
        echo "This will remove ALL this author's data, including removing this author from any books."
        mysql --table -u root library -e "SELECT * FROM tbl_author WHERE authorId = \"$authID\""
        read -p  "Type DELETE to delete, or anything else to cancel. >" deleteAuthorConfirm
        
        if [ "$deleteAuthorConfirm" = "DELETE" ]; then
            echo
            echo "Deleting author..."
            mysql --table -u root library -e "CALL delAuthorAdmin(\"$authID\")"
            echo "Author record deleted."
            echo
            sleep 2
        else
            echo "Deletion cancelled."
            echo
            sleep 2
        fi
    else
        echo "Deletion cancelled."
        echo
        sleep 2
    fi
}

# Menu to make changes to the genre table
genreMenu(){
    keepDoingGenreMenu=1
    while [ $keepDoingGenreMenu -ne 0 ]; do
        clear
        echo "~~~~~~~~~~~~~~~"
        echo "  GENRE MENU  "
        echo "~~~~~~~~~~~~~~~"
        echo 
        menu "What would you like to do to the genre records? " -o "Add" "Update" "Delete" -x "Back to Administrator Menu"
        
        choice=$FUNC_RET
        case $choice in
            1) addGen ;;
            2) updateGen ;;
            3) deleteGen ;;
            0)
                keepDoingGenreMenu=0
                echo
                echo "Returning to previous menu."
                sleep 2
            ;;
        esac
    done
}

# Add a new genre record
addGen(){
	echo "~~~~~~~~~~~~~~~~~"
	echo "  GENRE RECORDS  "
	echo "~~~~~~~~~~~~~~~~~"
    echo 
	mysql --table -u root library -e "SELECT * FROM tbl_genre"

	echo
	read -p "Please enter the name of the genre: " genName
	
	mysql --table -u root library -e "CALL addGenre(\"$genName\")"
	echo "Genre added"
	echo
    sleep 2
}

# Update a genre record
updateGen(){
	echo "~~~~~~~~~~~~~~~~~"
	echo "  GENRE RECORDS  "
	echo "~~~~~~~~~~~~~~~~~"
    echo 
	mysql --table -u root library -e "SELECT * FROM tbl_genre"
	
	echo
	read -p "Please enter the Genre ID of the record you would like to update: " genID
	echo
	read -p "Please enter the new name of the genre or enter N/A for no change: " genName
	
	mysql --table -u root library -e "CALL updateGenre(\"$genID\", \"$genName\")"
	echo "Genre updated"
	echo
    sleep 2
}

# Delete a genre record
deleteGen(){
	echo "~~~~~~~~~~~~~~~~~"
	echo "  GENRE RECORDS  "
	echo "~~~~~~~~~~~~~~~~~"
    echo 
	mysql --table -u root library -e "SELECT * FROM tbl_genre"
	
	echo
	read -p "Please enter the Genre ID of the record you would like to delete: " genID
	
	mysql --table -u root library -e "CALL deleteGenre(\"$genID\")"
	echo "Genre deleted"
	echo
    sleep 2
} # come back to this

######################################################################################

# Menu to make changes to the publisher table
pubMenu(){
    keepDoingPubMenu=1
    while [ $keepDoingPubMenu -ne 0 ]; do
		clear
        echo "~~~~~~~~~~~~~~~~~~"
        echo "  PUBLISHER MENU  "
        echo "~~~~~~~~~~~~~~~~~~"
        echo 
        menu "What would you like to do to the publisher records? " -o "Add" "Update" "Delete" -x "Back to Administrator Menu"
        
        choice=$FUNC_RET
        case $choice in
            1) addPub ;;
            2) updatePub ;;
            3) deletePub ;;
            0)
                keepDoingPubMenu=0
                echo
                echo "Returning to previous menu."
                sleep 2
            ;;
        esac
    done
}

# Add a new publisher record
addPub(){
	echo "~~~~~~~~~~~~~~~~~~~~~"
	echo "  PUBLISHER RECORDS  "
	echo "~~~~~~~~~~~~~~~~~~~~~"
    echo 
	mysql --table -u root library -e "SELECT * FROM tbl_publisher"

	echo
	read -p "Please enter the name of the publisher: " pubName
	echo
	read -p "Please enter the address of the publisher: " pubAddress
	echo
	read -p "Please enter the phone number of the publisher: " pubPhone
	
	mysql --table -u root library -e "CALL addPublisher(\"$pubName\", \"$pubAddress\", \"$pubPhone\")"
	echo "Publisher added"
	echo
    sleep 2
}

# Update a publisher record
updatePub(){
	echo "~~~~~~~~~~~~~~~~~~~~~"
	echo "  PUBLISHER RECORDS  "
	echo "~~~~~~~~~~~~~~~~~~~~~"
    echo 
	mysql --table -u root library -e "SELECT * FROM tbl_publisher"

	echo
	read -p "Please enter the Publisher ID of the record you would like to update: " pubID
	echo
	read -p "Please enter the new name of the publisher or enter N/A for no change: " pubName
	echo
	read -p "Please enter the new address of the publisher or N/A for no change: " pubAddress
	echo
	read -p "Please enter the new phone number of the publisher or N/A for no change: " pubPhone
	
	mysql --table -u root library -e "CALL updatePublisher(\"$pubID\", \"$pubName\", \"$pubAddress\", \"$pubPhone\")"
	echo "Publisher updated"
	echo
    sleep 2
}

# Delete a publisher record
deletePub(){
	echo "~~~~~~~~~~~~~~~~~~~~~"
	echo "  PUBLISHER RECORDS  "
	echo "~~~~~~~~~~~~~~~~~~~~~"
    echo 
	mysql --table -u root library -e "SELECT * FROM tbl_publisher"

	echo
	read -p "Please enter the Publisher ID of the record you would like to delete: " pubID
	
	mysql --table -u root library -e "CALL deletePublisher(\"$pubID\")"
	echo "Publisher deleted"
	echo
    sleep 2
}

#####################################################################################

# Menu to make changes to the borrower
borrMenu(){

    keepDoingBorrMenu=1
    while [ $keepDoingBorrMenu -ne 0 ]; do
	clear
        echo "~~~~~~~~~~~~~~~~~"
        echo "  BORROWER MENU  "
        echo "~~~~~~~~~~~~~~~~~"
        echo 
        menu "What would you like to do to the borrower records? " -o "Add" "Update" "Delete" -x "Back to Administrator Menu"
        
        choice=$FUNC_RET
        case $choice in
            1) addBorr ;;
            2) updateBorr ;;
            3) deleteBorr ;;
            0)
                keepDoingBorrMenu=0
                echo
                echo "Returning to previous menu."
                sleep 2
            ;;
        esac
    done
}

# Add a new borrower record
addBorr(){
	echo "~~~~~~~~~~~~~~~~~~~~"
	echo "  BORROWER RECORDS  "
	echo "~~~~~~~~~~~~~~~~~~~~"
    echo 
	mysql --table -u root library -e "SELECT * FROM tbl_borrower"

	echo
	read -p "Please enter the name of the borrower: " borrName
	echo
	read -p "Please enter the address of the borrower: " borrAddress
	echo
	read -p "Please enter the phone number of the borrower: " borrPNumber
	
	mysql --table -u root library -e "CALL addBorrowerAdmin(\"$borrName\", \"$borrAddress\", \"$borrPNumber\")"
	echo "Borrower added"
	echo
    sleep 2
}

# Update a branch record
updateBorr(){
	echo "~~~~~~~~~~~~~~~~~~~~"
	echo "  BORROWER RECORDS  "
	echo "~~~~~~~~~~~~~~~~~~~~"
    echo 
	mysql --table -u root library -e "SELECT * FROM tbl_borrower"
	
	echo
	read -p "Please enter the Card Number of the record you would like to update: " borrID
	echo
	read -p "Please enter the new name of the borrower or enter N/A for no change: " borrName
	echo
	read -p "Please enter the new address of the borrower or N/A for no change: " borrAddress
	echo
	read -p "Please enter the new phone number of the borrower or N/A for no change: " borrPNumber
	
	mysql --table -u root library -e "CALL updateBorrowerAdmin(\"$borrID\", \"$borrName\", \"$borrAddress\", \"$borrPNumber\")"
	echo "Borrower updated"
	echo
    sleep 2
}

# Delete a branch record
deleteBorr(){
	echo "~~~~~~~~~~~~~~~~~~~~"
	echo "  BORROWER RECORDS  "
	echo "~~~~~~~~~~~~~~~~~~~~"
    echo 
	mysql --table -u root library -e "SELECT * FROM tbl_borrower"
	
	echo
	read -p "Please enter the Card Number of the record you would like to delete: " borrID
	
	mysql --table -u root library -e "CALL delBwAdmin(\"$borrID\")"
	echo "Borrower deleted"
	echo
    sleep 2
}

#################################################################

mainMenu