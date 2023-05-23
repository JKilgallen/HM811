pkg load image;

function grating = get_gratings(H=1920, W=1080, UPSCALE_FACTOR=2, BAR_WIDTH=1, INNER_RADIUS=0, FLICKER=false)

    [X,Y] = meshgrid(-W*UPSCALE_FACTOR/2:1:W*UPSCALE_FACTOR/2-1, -H*UPSCALE_FACTOR/2:1:H*UPSCALE_FACTOR/2-1);
    mapping = repelem(repmat([1; 0], (W/BAR_WIDTH)/2, 1), BAR_WIDTH*UPSCALE_FACTOR);
    offset = FLICKER*BAR_WIDTH*UPSCALE_FACTOR;
    mapping = circshift(mapping, offset);
    grating = repmat(mapping, 1, H*UPSCALE_FACTOR);
    grating(sqrt(X.^2 + Y.^2) < INNER_RADIUS*UPSCALE_FACTOR) = FLICKER;
    grating = imresize(grating, [H W], "bicubic");
end

H = 1024; W = 1024;
FPS = 15;
UPSCALE_FACTOR = 4;
BAR_WIDTH = 16;
INNER_RADIUS = 0;
animation_out = sprintf('../reports/plots/gratings_flicker_%i_%i_%i_%i_%i.gif', H, W, UPSCALE_FACTOR, BAR_WIDTH, INNER_RADIUS);


image_1 = get_gratings(H, W, UPSCALE_FACTOR, BAR_WIDTH, INNER_RADIUS, true);
image_2 = get_gratings(H, W, UPSCALE_FACTOR, BAR_WIDTH, INNER_RADIUS, false);

imwrite(image_1, animation_out, 'gif', 'DelayTime', 1/FPS);
imwrite(image_2, animation_out, 'gif', 'WriteMode', 'append', 'DelayTime', 1/FPS);

static_image_out = sprintf('../reports/plots/gratings_static_%i_%i_%i_%i.png', H, W, UPSCALE_FACTOR, BAR_WIDTH);
static_image = get_gratings(H, W, UPSCALE_FACTOR, BAR_WIDTH, 0, false);
imwrite(static_image, static_image_out);