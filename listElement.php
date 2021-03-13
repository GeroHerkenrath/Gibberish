<?php
// constants
const ICONS = array(
    'sun.max.fill', 'sparkles', 'flag.fill', 'bell.circle.fill', 'pin.circle.fill', 
    'gift.fill', 'filemenu.and.selection', 'car.circle.fill', 'airplane.circle.fill', 'leaf.fill'
);
const LABELS = array(
    'Flora', 'Carlton', 'Wilbur', 'Braiden', 'Krystal', 
    'Finnian', 'Marcel', 'Athena', 'Marguerite', 'Kiera'
);

// boring pre-work
header_remove();
header('Cache-Control: no-store, no-cache, must-revalidate, max-age=0');
header('Cache-Control: post-check=0, pre-check=0', false);
header('Pragma: no-cache');
header('Content-Type: application/json');

// parameter getting & validation
$responseDelay = htmlspecialchars($_GET['responseDelay']); // required
if (!is_numeric($responseDelay)) {
    giveBadResponse(); // also exits
}
$actualDelay = min(max(0, intval($responseDelay)), 5000); // max 5 second delay

$minWordCount = htmlspecialchars($_GET['minWordCount']); // optional
if ($minWordCount !== '' && is_numeric($minWordCount)) {
    $minWordCount = max(intval($minWordCount), 10);
} else {
    $minWordCount = 10;
}

$maxWordCount = htmlspecialchars($_GET['maxWordCount']); // optional
if ($minWordCount !== '' && is_numeric($minWordCount)) {
    $maxWordCount = max(intval($maxWordCount), $minWordCount + 5);
} else {
    $maxWordCount = $minWordCount + 5;
}

// start doing something: sleep & respond
usleep($actualDelay * 1000);
http_response_code(200);
header('Status: 200');
echo generateResponseBody($minWordCount, $maxWordCount), PHP_EOL;

// *****************

// the schmeat: 'calculate' something...
function generateResponseBody($minText, $maxText) {
    return json_encode(array(
        'icon' => getIconName(random_int(0, 9)),
        'label' => getLabelText(random_int(0, 9)),
        'text' => getRandomText($minText, $maxText),
        'minWordCount' => $minText,
        'maxWordCount' => $maxText
    ));
}

function getIconName($withNumber) {
    return ICONS[max(0, min($withNumber, count(ICONS) - 1))];
}

function getLabelText($withNumber) {
    return LABELS[max(0, min($withNumber, count(LABELS) - 1))];
}

function getRandomText($min, $max) {
    $foreignPayload = file_get_contents("https://www.randomtext.me/api/gibberish/p-1/{$min}-{$max}");
    $foreignJson = json_decode($foreignPayload, true);
    $foreignText = $foreignJson['text_out'];
    return substr($foreignText, 3, -5); // remove tags and stuff
}

// error handling (400 and exit)
function giveBadResponse($message = 'Bad Request') {
    http_response_code(400);
    header('Status: 400');
    echo json_encode(array(
        'status' => 400,
        'message' => $message
        )), PHP_EOL;
    exit();
}
?>