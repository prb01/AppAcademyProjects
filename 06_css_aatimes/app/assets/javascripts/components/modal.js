/* global $ */

const toggleModal = () => {
	$("#search-modal").toggleClass('expand')
	$("#overlay").toggleClass('hidden-overlay')
};

// Add click listener to search icon which invokes sidebar function
$(() => $('#search-modal-btn').on('click', toggleModal));

// Add click listener to overlay
$(() => $('#overlay').on('click', toggleModal));

// Add click listener to close button
$(() => $('.close').on('click', toggleModal));


