fields = {}

fields.order = {'Salad', 'Stew', 'Salsa', 'Tea'}
fields.Salad = {
    allowedPlants = {'Lettuce', 'Radish'},
    Pest = 'LazyGopher',
    maxPests = 2,
    rows = 5,
    columns = 5,
    initialWeights = {Lettuce=42, Radish=43, Mallet=5},
    Weights = initialWeights,
    X = 380,
    Y = 126,
    W = 625,
    H = 625,
    bg_w = 1024,
    bg_h = 768,
    bg = 'images/field5x5.png',
    thumb = 'images/fieldPreviewSalad.png',
    thumb_dis = 'images/fieldPreviewSaladLocked.png',
    monster = 'images/evilGopherGod.png',
    Queue = {X = 175, Y=425, W=100},
    Basket = {X = 175, Y=626, W=100},
    blocked = {},
    minScore = 0,
}
function fields.Salad.updateWeights()
    mallet_weights()
    plants = 100-theQueue.weights.Mallet
    theQueue.weights.Lettuce = math.floor(plants/2)
    theQueue.weights.Radish = math.ceil(plants/2)
    print('--fields.lua def:  updateWeights')
end

fields.Stew = {
    allowedPlants = {'Celery', 'Potato', 'Carrot'},
    Pest = 'Crow',
    rows = 6,
    columns = 7,
    initialWeights = {Potato = 29, Carrot = 28, Celery = 28},
    Weights = initialWeights,
    X = 380,
    Y = 126,
    W = 875,
    H = 750,
    bg_w = 1256,
    bg_h = 878,
    bg = 'images/field6x6.png',
    thumb = 'images/fieldPreviewStew.png',
    thumb_dis = 'images/fieldPreviewStewLocked.png',
    monster = 'images/crowGod.png',
    Queue = {X = 175, Y=425, W=100},
    Basket = {X = 175, Y=626, W=100},
    blocked = {{5, 1}, {5, 2}, {5, 3}, {5, 4}, {5, 5}, {5,6}},
    minScore = 120,
}
function fields.Stew.updateWeights(queue, field)
    slingshot_weights()    
    plants = 100-theQueue.weights.Slingshot
    theQueue.weights.Potato = math.floor(plants/3)
    theQueue.weights.Carrot = math.floor(plants/3)
    theQueue.weights.Celery = 100-2*math.floor(plants/3)
    print('--fields.lua def:  updateWeights')
end

fields.Salsa = {
    allowedPlants = {'Tomato', 'Jalapeno'},
    Pest = 'SmartGopher',
    maxPests = 4,
    rows = 8,
    columns = 8,
    initialWeights = {Tomato=42, Jalapeno=43, Mallet=5},
    Weights = initialWeights,
    X = 380,
    Y = 126,
    W = 1000,
    H = 1000,
    bg_w = 1381,
    bg_h = 1128,
    bg = 'images/fieldSalsa.png',
    thumb = 'images/fieldPreviewSalsa.png',
    thumb_dis = 'images/fieldPreviewSalsaLocked.png',
    monster = 'images/evilGopherGod.png',
    Queue = {X = 175, Y=425, W=100},
    Basket = {X = 175, Y=626, W=100},
    blocked = {{5,1}, {5, 2}, {5, 3}, {6, 3}, {3, 6}, {4, 6}, {4, 7}, {4, 8}},
    minScore = 500,
}
function fields.Salsa.updateWeights()
    mallet_weights()
    plants = 100-theQueue.weights.Mallet
    theQueue.weights.Tomato = math.floor(plants/2)
    theQueue.weights.Jalapeno = math.ceil(plants/2)
    print('--fields.lua def:  updateWeights')
end

fields.Tea = {
    allowedPlants = {'Mint', 'Chamomile'},
    Pest = 'Cockatrice',
    rows = 8,
    columns = 9,
    initialWeights = {Mint=42, Chamomile=43},
    Weights = initialWeights,
    X = 380,
    Y = 126,
    W = 1125,
    H = 1000,
    bg_w = 1506,
    bg_h = 1128,
    bg = 'images/fieldYingYang.png',
    thumb = 'images/fieldPreviewTea.png',
    thumb_dis = 'images/fieldPreviewTeaLocked.png',
    monster = 'images/cockatriceGod.png',
    Queue = {X = 175, Y=425, W=100},
    Basket = {X = 175, Y=626, W=100},
    blocked = {{3, 3}, {3, 4}, {4, 3}, {4, 4}, {6, 5}, {6, 6}, {7, 5}, {7, 6}},
    minScore = 1000,
}
function fields.Tea.updateWeights()
    slingshot_weights()
    plants = 100-theQueue.weights.Slingshot
    theQueue.weights.Mint = math.floor(plants/2)
    theQueue.weights.Chamomile = math.ceil(plants/2)
    print('--fields.lua def:  updateWeights')
end

 function slingshot_weights()
    if theQueue[#theQueue].square_type == 'Slingshot' then
        theQueue.weights.Slingshot = 0
    elseif theBasket.box.type == 'Slingshot' then
        theQueue.weights.Slingshot = 5
    else
        theQueue.weights.Slingshot = 15
    end
end
function mallet_weights()
    if theQueue[#theQueue].contents.type == 'Mallet' then
        theQueue.weights.Mallet = 0
    elseif theBasket.box.contents.type=='Mallet' then
        theQueue.weights.Mallet = 5+10*(#theField.elements.Pest)
    else
        theQueue.weights.Mallet = 15+15*(#theField.elements.Pest)
    end
end