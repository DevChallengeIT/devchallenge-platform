function updateTimer(id, distance) {
  console.log('id: ', id);
  console.log('distance: ', distance);

  // Time calculations for days, hours, minutes and seconds
  const days = Math.floor(distance / (1000 * 60 * 60 * 24));
  const hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
  const minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
  const seconds = Math.floor((distance % (1000 * 60)) / 1000);

  document.getElementById(id).innerHTML = days + "d " + hours + "h " + minutes + "m " + seconds + "s";
}

export { updateTimer };
