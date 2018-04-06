import styled from "styled-components";
import _AppBar from "material-ui/AppBar";
import IconButton from "material-ui/IconButton";
import { colors, sizes, breakpoints, fonts } from "/client/imports/theme";

export const AppBarContainer = styled.div`
  position: relative;
  height: 78px;
`;
export const AppBar = styled(_AppBar)`
  && {
    transition: box-shadow 200ms;
    width: 100%;
    & > div {
      background-color: ${colors.background.default};
    }
  }
`;
export const MenuButtonContainer = styled(IconButton)``;
export const Title = styled.div`
  font-family: ${fonts.header};
  color: #454545;
  font-weight: 500;
  font-size: 1.2rem;
  margin-top: 2px;
  letter-spacing: 0.03rem;
`;
