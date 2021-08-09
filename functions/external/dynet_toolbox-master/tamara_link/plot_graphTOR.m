function [fig]= plot_graphTOR(adjmat, coor, max_w,min_w, thr, backgr, labels, graphtitle)
%% (for TOR experiment) PLOT GRAPH FROM THE ADJACENCY MATRIX
% For 10 ROI. DO_TO: make it flexible

% adjmat = squeeze(ADJmat(:,:,400)/10);
% adjmat = th_mat; 
% labels = VSDI.roi.labels

adjmat(adjmat<thr) = 0;

% G = graph(thr_mat,'upper'); 
G = digraph(adjmat); 


        % Node Names
        for ii= 1:length(labels)
        % names{jj}=strcat( VSDI.roi.labels{ii}(end), VSDI.roi.labels{ii}(1:end-2));
        names{ii}=strcat( labels{ii}(end), labels{ii}(1:end-2));
        end

        % In a directed graph, the edges have the direction row-to-column

        %% SETTINGS TO BE ADJUSTED IN THE PLOT

        % NODE POSITION (coordinates)
        pos = coor; 
%         pos(1,:) = [35,12];
%         pos(2,:) = [57,12];
%         pos(3,:) = [18,15];
%         pos(4,:) = [75,14];
%         pos(5,:) = [38,35];
%         pos(6,:) = [52,34];
%         pos(7,:) = [25,23];
%         pos(8,:) = [68,23];
%         pos(9,:) = [38,48];
%         pos(10,:) = [50,48];


        % NODE COLOR
        node_color = zeros(3,10);
        % Right hemisphere nodes
        node_color(:,1) = [0 128 129]; %- blue
        node_color(:,3) = [0 168 107]; %V1 -  jade
        node_color(:,5) = [240 128 128]; % - light coral
        node_color(:,7) = [209 211 212]; %HLS1 - grey
        node_color(:,9) = [255 187 0]; % - yellow
        node_color(:,11) = [255 50 0]; % - 
        
        % Left hemisphere nodes
        node_color(:,2) = [0 128 129]; %- blue
        node_color(:,4) = [0 168 107]; %V1 -  jade
        node_color(:,6) = [240 128 128]; % - light coral
        node_color(:,8) = [209 211 212]; %HLS1 - grey
        node_color(:,10) = [255 187 0]; % - yellow
        node_color(:,12) = [255 50 0]; % - 

        node_color = node_color'./255;

        % NODE SIZE(linear mapping into min-max interval)
        %     node_weight=sum(adjmat,2); % calculate node out strength
        %     max_node_weight=max(node_weight);
        %     node_weight(~node_weight) = inf; % replace any zeros w/ inf to calculate nonzero min
        %     min_node_weight=min(node_weight);
        %     node_weight(isinf(node_weight)) = min_node_weight; % replace infs with minimum node weight
        %     % Calculate slope and intercept for linear function
        %     min_size=15.; max_size=40.;
        %     m=(max_size-min_size)/(max_node_weight-min_node_weight);
        %     b= max_size-m*max_node_weight;
        %     % Use linear function to set node size proporational to node weight
        %     for i=1:size(adjmat,1)
        %           tmp = [b+m*node_weight(i)];  % linear function F(x)= mx+b
        %           nodes_size(i) = tmp; 
        %     end

        % % FONT SIZE (also using linear function)
        % min_fsize=12; max_fsize=20.;
        % m=(max_fsize-min_fsize)/(max_node_weight-min_node_weight);
        % b= max_fsize-m*max_node_weight;
        % 
        % %  Set font size proportional to the node weight.
        % for i=1:num_nodes
        %     tmp = round(b+m*node_weight(i)); %Needs full integers
        %     fontsize=tmp;
        % end

        % % EDGE WIDTH
        min_lwidth=1.; max_lwidth=8.;

        % max_w=max(max(alldata(:)));
        % tmp = alldata(:); tmp(~tmp) = inf; % replace any zeros w/ inf to calculate nonzero min
        % min_w=min(min(tmp));

        m=(max_lwidth-min_lwidth)/(max_w-min_w);
        b=max_lwidth-m*max_w;
        % Set line widths proportional to edge weights - use power to increase the
        % range of widths
        for i=1:length(G.Edges.Weight)
            edges(i)=min_w+m*(((G.Edges.Weight(i))/b)^2);
        end

        % EDGE COLOR (to match the color of the sender node)
        for i =1:length(G.Edges.Weight)
            sendercolor(i,:) = node_color(G.Edges.EndNodes(i),:);
        end

        %% PLOT
        G.Nodes.Name  = names'; % it has to be changed in the end, otherwise, the loop for assignment of sendercolor will not work

        % Plot image of the brain
        fig = figure;
        ax = axes
        imagesc(backgr); colormap('bone')
        hold on

        % Plot Graph
        p = plot(G);
        ax = gca; 
        ax.YDir = 'reverse';
        ax.Visible = 'off';

        % Coordinates of the nodes:
        p.XData = pos(:,1);
        p.YData = pos(:,2);

        p.NodeColor = node_color; % Node Color
        % p.MarkerSize = nodes_size; % Node Size proportional to the output
        p.MarkerSize = 12;
        % p.NodeFontSize = fontsize; % Font size
        p.NodeLabel = {}; %uncomment if we want to hide the node labels (don't delete them from the graph, just from the plot)
        
        if ~isempty(G.Edges)
        p.LineWidth = edges;
        p.EdgeColor = sendercolor;
        end
sgtitle(graphtitle)
        
end

%% Updated: 09/06/21 (from Venice)
% non-fixed 'pos' coordinates: to be input from circular rois