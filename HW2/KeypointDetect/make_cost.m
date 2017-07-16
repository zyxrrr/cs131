

function c = make_cost(k1, k2)

        for i=1:size(k1,1)
            for k=1:size(k2,1)
                
                c(i,k) = sum((k1(i,:) - k2(k,:)).^2);
            end
        end
        
                