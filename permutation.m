% Given the letter counts as an array B, return the matching permutation of
% 1 to 26.
function A = permutation(B)

    A = msort( [B ; 1:length(B)] );
    A = A(2,:);

end

% Merge sort
function b = msort(a)

    % Number of columns
    n = size(a, 2);

    if n <= 1
        % Base case: length 1 arrays are sorted
        b = a;
    else
        % Recursive step: split input in two halves
        a1 = a(:, 1:floor(n/2));
        a2 = a(:, floor(n/2)+1:n);

        % Sort halves recursively and merge
        b = merge(msort(a1), msort(a2));
    end
end

% Merge
function c = merge( a,b )

    % Pre-allocate for number of rows
    c = zeros(2, size(a,2) + size(b,2));

    % Initialize array indices
    i = 1 ; j = 1 ; k = 1 ;

    % Repeat while both a and b have elements remaining
    while i <= size(a,2) && j <= size(b,2)
        % Find larger of both "next" elements
        if a(1,i) < b(1,j)
            % Put column from a onto c
            c(:,k) = a(:,i) ; i = i+1 ; k = k+1 ;
        else
            % Put column from b onto c
            c(:,k) = b(:,j) ; j = j+1 ; k = k+1 ;
        end
    end

    % Copy remainder of a (if any)
    while i <= size(a,2)
        c(:,k) = a(:,i) ; i = i+1 ; k = k+1 ;
    end

    % Copy remainder of b (if any)
    while j <= size(b,2)
        c(:,k) = b(:,j) ; j = j+1 ; k = k+1 ;
    end

end