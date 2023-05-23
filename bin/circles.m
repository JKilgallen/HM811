pkg load image;

function circles = get_circles(H=1920, W=1080, UPSCALE_FACTOR=2, CIRCLE_WIDTH=1, INNER_RADIUS=0, FLICKER=false)

    [X,Y] = meshgrid(-W*UPSCALE_FACTOR/2:1:W*UPSCALE_FACTOR/2, -H*UPSCALE_FACTOR/2:1:H*UPSCALE_FACTOR/2);
    mapping = repelem(repmat([1; 0], round(sqrt(H^2+W^2)/2), 1), UPSCALE_FACTOR*CIRCLE_WIDTH);
    offset = FLICKER*UPSCALE_FACTOR*CIRCLE_WIDTH;
    mapping = circshift(mapping, offset);
    mapping(1:INNER_RADIUS*UPSCALE_FACTOR) = FLICKER;

    f = @(x,y) mapping(round(sqrt(x.^2+y.^2)) + 1);
    circles = f(X, Y);

    circles = imresize(circles, [H W], "bicubic");
end

H = 1024; W = 1024;
FPS = 15;
UPSCALE_FACTOR = 4;
CIRCLE_WIDTH = 8;
INNER_RADIUS = 128;
animation_out = sprintf('../reports/plots/circle_flicker_%i_%i_%i_%i_%i.gif', H, W, UPSCALE_FACTOR, CIRCLE_WIDTH, INNER_RADIUS);


image_1 = get_circles(H, W, UPSCALE_FACTOR, CIRCLE_WIDTH, INNER_RADIUS, true);
image_2 = get_circles(H, W, UPSCALE_FACTOR, CIRCLE_WIDTH, INNER_RADIUS, false);

imwrite(image_1, animation_out, 'gif', 'DelayTime', 1/FPS);
imwrite(image_2, animation_out, 'gif', 'WriteMode', 'append', 'DelayTime', 1/FPS);

static_image = get_circles(H, W, UPSCALE_FACTOR, CIRCLE_WIDTH, 0, false);
static_image_out = sprintf('../reports/plots/circle_static_%i_%i_%i_%i.png', H, W, UPSCALE_FACTOR, CIRCLE_WIDTH);
imwrite(static_image, static_image_out);