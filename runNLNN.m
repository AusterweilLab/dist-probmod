function [Ys Zs] = runNLNN( X, l_rate, maxEpochs )
    %runNLNN creates a non-linear neural network that learns X using learning rate
    %l_rate, and returns the learned matrix X_NLNN
    %   Detailed explanation goes here
    Ys = cell(maxEpochs,1);
    Zs = cell(maxEpochs,1);


    %Y = N by K matrix, K >= rank of X, Y is like the weights
    K = rank(X) + 1;
    Y = random('norm',0,.05,[size(X,1),K]);

    %Z = random K by M matrix, Z is like the representations, the hidden layer
    %activations, we assume it follows a multivariate gaussian dist with mean 0
    %and covariance sig^2I
    % **********I totally don't get this so I just use a random matrix*********
    Z = random('norm',0,.05,[K,size(X,2)]);
    % perform gradient descent on Z and Y, alternating between the two
    % GD on Z
    for curEpoch = 1:maxEpochs
        delta_z = zeros(size(Z));
        for curZcol = 1:size(Z,2)
            delta_z(:,curZcol) = l_rate * Y'* (X(:,curZcol) - Y*Z(:,curZcol));
        end
        Z = Z + delta_z;
        Zs{curEpoch} = Z;

        % GD on Y
        delta_y = zeros(size(Y));
        for curYrow = 1:size(Y,1)
            delta_y(curYrow,:) = l_rate * (X(curYrow,:) - Y(curYrow,:)*Z) * Z';
        end
        Y = Y + delta_y;
        Ys{curEpoch} = Y;
%         if (mod(curEpoch,10) == 0)
%             disp(['curr error: ' num2str(sum(sum((X-Y*Z).^2)))]);
%         end
    end

    if sum(sum(X-Y*Z)) > 1
        disp('WARNING: NN error > 1');
    end
%     X_NN = Y*Z;
end
