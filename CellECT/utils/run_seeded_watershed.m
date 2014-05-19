function run_seeded_waterhsed(input_mat_file, output_mat_file)

debug = false;
display3d = false;

p = path;
path(p, [pwd, '/fast_marching']);

load (input_mat_file, 'vol', 'sbx', 'sby', 'sbz','seeds', 'bg_mask');

background_seeds = [sbx(:), sby(:), sbz(:)];

number_seeds = size(seeds,1) -2;

        

start_pts_mask = [];
if size(bg_mask,1)>0
    start_pts_mask = bg_mask;
else
    start_pts_mask = zeros(size(vol));
end


% if ~strcmp(class(seeds),'cell')
% 	seeds = squeeze(seeds);
% % 	if size(seeds,1) == 3
% % 		seeds = seeds';
% % 	end
% end



for i = 1:number_seeds
    seed_group = floor(seeds{i} + 1);
    if size(seed_group,1) >1
        min_box = min(seed_group,[],1);
        max_box = max(seed_group,[],1);
        min_box = max(min_box - 10, 1);
        max_box = min(max_box + 10, cast(size(vol), class(max_box)));
        one =  seed_group(:,1) - min_box(1)+1;
        two =  seed_group(:,2) - min_box(2)+1;
        three = seed_group(:,3) - min_box(3) +1;
        input = [ one, two, three ];
        input = double(input);
        output = connect_seeds(vol(min_box(1):max_box(1), min_box(2):max_box(2), min_box(3):max_box(3)), input, start_pts_mask(min_box(1):max_box(1), min_box(2):max_box(2), min_box(3):max_box(3)), min_box);
        start_pts_mask(min_box(1):max_box(1), min_box(2):max_box(2), min_box(3):max_box(3)) = output;
    else
        start_pts_mask(seed_group(1), seed_group(2), seed_group(3)) = 1;     
        if debug
            plot3(seed_group(1), seed_group(2), seed_group(3) ,'k.','markersize',15);
            hold on
        end
    end
          
        
        
% 	for x = -0:1
% 		for y = -0:1
% 			for z = -0:1
% 				xloc = max( round(seeds(1,i)+1) + x, 1);
% 				xloc = min( xloc, size(vol,1));
% 
% 				yloc = max( round(seeds(2,i)+1) + y, 1);
% 				yloc = min( yloc, size(vol,2));
% 
% 				zloc = max( round(seeds(3,i)+1) + z, 1);
% 				zloc = min( zloc, size(vol,3));
% 				
% 			    start_pts_mask(xloc, yloc,zloc) = 1;
% 			end
% 		end
%     end
end


for i = 1:size(background_seeds,1)
	background_seeds(i,1) = max( round(background_seeds(i,1)+1) , 1);
    xloc = background_seeds(i,1) ;
	xloc = min( xloc, size(vol,1));

	background_seeds(i,2) = max( round(background_seeds(i,2)+1) , 1);
    yloc = background_seeds(i,2);
	yloc = min( yloc, size(vol,2));

    background_seeds(i,3) = max( round(background_seeds(i,3)+1) , 1);
    zloc = background_seeds(i,3);
	zloc = min( zloc, size(vol,3));
				
    start_pts_mask(xloc, yloc,zloc) = 1;
end

bg_mask_sum = sum(bg_mask(:));

has_bg = (size(background_seeds,1)>0) | (bg_mask_sum>0);


% if it has background, assume that this background surrounds the object of interest.
% Note: change this is not accurate
% if has_bg
% 	start_pts_mask(:,1,:) = 1;
% 	start_pts_mask(:,end-1,:) = 1;
% 	start_pts_mask(1,:,:) = 1;
% 	start_pts_mask(end-1,:,:) = 1;
% end

% if there are no nuclei (just dummy) and no background, then just return one big box

% if (size(seeds,2) == 1) & (~has_bg)
% 
% 	ws = ones(size(vol));
% 
% 	ws(:,:,1) = zeros(size(vol,1), size(vol,2));
% 	ws(:,:,end) = zeros(size(vol,1), size(vol,2));
% 	ws(:,1,:) = zeros(size(vol,1),size(vol,3));
% 	ws(:,end,:) = zeros(size(vol,1),size(vol,3));
% 	ws(1,:,:) =  zeros(size(vol,2),size(vol,3));
% 	ws(end,:,:) =  zeros(size(vol,2),size(vol,3));
% 
% else
% 	% actually run watershed
% 	vol = imimposemin (vol, start_pts_mask);
% 
% 	ws = watershed(vol);
% end

if (number_seeds < 1)
    ws = ones(size(vol));
else
    if ((number_seeds >= 1) & ( has_bg ) ) | (number_seeds>1)
        % run watershed if at least one other background seed
        vol = imimposemin (vol, start_pts_mask);
        ws = watershed(vol);
    else
        % make everythign label 1 (this will get boosted to 2 later)
        ws =  ones(size(vol));
    end
end


% move segment labels to starts at 2, because 1 will be given to bg
% segments

mask = cast(ws >=1, class(ws));
ws = ws+mask; 


% make label 1 for everything background from connected components in
% bg_mask

if bg_mask_sum
   
    labels = unique(cast(bg_mask, class(ws)) .* ws);
    for label = labels'
       if label ~=0
           mask = cast(ws == label, class(ws));
           ws = mask + (1-mask).*ws;
       end
    end
    
end


% make label 1 for everything that is background from seeds
for i = 1:size(background_seeds,1)
    label = ws(background_seeds(i,1), background_seeds(i,2), background_seeds(i,3));
    if label ~=0
        mask = cast(ws == label, class(ws));
        ws = mask + (1-mask).*ws;
    end
end




% if (~has_bg) && (size(seeds,2)>0)
% % if it doesnt have a bg, skip label 1 since this is reserved for background
% 	try
% 		ws = ws + uint16(ws>0);
% 	catch
% 		try
% 			ws = ws + uint8(ws>0);
% 		catch
% 			ws = ws + double(ws>0);
% 		end
% 	end
% end

% remove background boundary
if (size(background_seeds,1)>1) | (bg_mask_sum)
    mask = (ws > 1);
    
    mask = convn(logical(mask),[1 1 1;1 1 1;1 1 1],'same')>=1;
    mask = convn(logical(mask),[1 1 1;1 1 1;1 1 1],'same')>=1;
    mask = cast(mask, class(ws));
    
    ws = ws .* mask + (1-mask);
    
end

save (output_mat_file, 'ws');

if display3d
    figure
    [mx,my,mz] = meshgrid(0:1:size(ws,1)-1, 0:1:size(ws,2)-1, 0:1:size(ws,3)-1);
    recolored = reassign_labels_and_shuffle(ws);
    recolored = double(recolored<2)*double(max(ws(:)+1)) + recolored.* double(recolored>=2);
    xslice = [160];
    yslice = [];
    zslice = [70];
    slice(mx,my,mz,recolored, xslice, yslice, zslice);
    colormap colorcube
    shading interp
    colormapeditor
    
    figure
    slice(mx,my,mz,vol, xslice, yslice, zslice);
    colormap hot
    shading interp
end

quit

